# frozen_string_literal: true

require 'rails_helper'

describe InvitationToken do
  it 'should have valid default properties' do
    invitation_token = FactoryBot.build(:invitation_token)
    expect(invitation_token.valid?).to be_truthy
  end

  describe 'expires_at' do
    it 'should initialize by default' do
      invitation_token = FactoryBot.create(:invitation_token)
      expect(invitation_token.expires_at).to_not be_nil
    end

    it 'should initialize with the correct OPEN_FROM_INVITATION' do
      date = Time.new(2017, 11, 0o2, 0, 0)
      Timecop.freeze(date)
      invitation_token = FactoryBot.create(:invitation_token)
      expect(invitation_token.expires_at)
        .to be_within(1.minute)
        .of(date + described_class::OPEN_TIME_FOR_INVITATION)
    end
  end

  describe 'test_identifier_token_combination' do
    let(:other_person) { FactoryBot.create(:person) }

    let(:response) { FactoryBot.create(:response, :invited) }
    let(:token) { FactoryBot.create(:invitation_token, invitation_set: response.invitation_set) }

    let(:not_sent_response) { FactoryBot.create(:response) }
    let(:not_sent_token) { FactoryBot.create(:invitation_token) }

    it 'should return nil if there is no person with that identifier' do
      result = InvitationToken.test_identifier_token_combination('non_existent', token.token_plain)
      expect(result).to be_nil
    end

    it 'should return nil if the person has no responses' do
      result = InvitationToken.test_identifier_token_combination(other_person.external_identifier, 'nothing')
      expect(result).to be_nil
    end

    it 'should return nil if the token does not match any of the responses ' do
      person = response.protocol_subscription.person
      result = InvitationToken.test_identifier_token_combination(person.external_identifier, 'nothing')
      expect(result).to be_nil
    end

    it 'should return nil if the token matches an unsent response' do
      person = response.protocol_subscription.person
      result = InvitationToken.test_identifier_token_combination(person.external_identifier, not_sent_token.token_plain)
      expect(result).to be_nil
    end

    it 'should return nil if there is one that matches the description but the hashed token is provided' do
      person = response.protocol_subscription.person
      result = InvitationToken.test_identifier_token_combination(person.external_identifier, token.token)
      expect(result).to be_nil
    end

    it 'should return the invitation_token if there is one that matches the description' do
      person = response.protocol_subscription.person
      result = InvitationToken.test_identifier_token_combination(person.external_identifier, token.token_plain)
      expect(result).to eq response.invitation_set.invitation_tokens.first
    end

    it 'should return the invitation_token if there is one that matches the description and is completed' do
      response.update_attributes!(completed_at: Time.zone.now)
      person = response.protocol_subscription.person
      result = InvitationToken.test_identifier_token_combination(person.external_identifier, token.token_plain)
      expect(result).to eq response.invitation_set.invitation_tokens.first
    end
  end

  describe 'token_hash' do
    it 'should not allow duplicate token hashes' do
      tok = 'myinvitation_token'
      invitation_tokenone = FactoryBot.create(:invitation_token, token: 'myinvitation_token')
      expect(invitation_tokenone.token_plain).to eq tok
      expect(invitation_tokenone.token).to_not be_empty
      expect(invitation_tokenone.token.to_s).to_not eq tok
      expect(invitation_tokenone.valid?).to be_truthy
      invitation_tokenonetwo = FactoryBot.build(:invitation_token, token_hash: invitation_tokenone.token)
      expect(invitation_tokenonetwo.valid?).to be_falsey
      expect(invitation_tokenonetwo.errors.messages).to have_key :token_hash
      expect(invitation_tokenonetwo.errors.messages[:token_hash]).to include('is al in gebruik')
    end
    it 'should not accept a nil token_hash' do
      invitation_token = FactoryBot.build(:invitation_token)
      invitation_token.token_hash = nil
      expect(invitation_token.valid?).to be_falsey
      expect(invitation_token.errors.messages).to have_key :token_hash
      expect(invitation_token.errors.messages[:token_hash]).to include('moet opgegeven zijn')
    end
    it 'should not accept a blank token_hash' do
      invitation_token = FactoryBot.build(:invitation_token)
      invitation_token.token_hash = ''
      expect(invitation_token.valid?).to be_falsey
      expect(invitation_token.errors.messages).to have_key :token_hash
      expect(invitation_token.errors.messages[:token_hash]).to include('moet opgegeven zijn')
    end
  end

  describe 'token' do
    it 'should generate a token if no token is present' do
      invitation_tokenone = FactoryBot.create(:invitation_token)
      expect(invitation_tokenone.token).to_not be_empty
      expect(invitation_tokenone.token_plain).to_not be_empty
      expect(invitation_tokenone.valid?).to be_truthy
    end

    it 'should use the old token_plain if it is present' do
      pt_token = 'tokenhere'
      invitation_token = FactoryBot.create(:invitation_token, token: pt_token)
      expect(invitation_token.token_plain).to eq pt_token
    end

    it 'should only store encrypted versions of the token' do
      pt_token = 'tokenhere'
      invitation_token = FactoryBot.create(:invitation_token, token: pt_token)
      expect(invitation_token.token_plain).to_not be_blank

      invitation_token = InvitationToken.find(invitation_token.id)
      expect(invitation_token.token_plain).to be_blank
      expect(invitation_token.token).to_not be_blank
    end
  end

  describe 'invitation_set_id' do
    it 'should have one' do
      invitation_token = FactoryBot.build(:invitation_token, invitation_set_id: nil)
      expect(invitation_token.valid?).to be_falsey
      expect(invitation_token.errors.messages).to have_key :invitation_set_id
      expect(invitation_token.errors.messages[:invitation_set_id]).to include('moet opgegeven zijn')
    end
    it 'should work to retrieve an InvitationSet' do
      invitation_token = FactoryBot.create(:invitation_token)
      expect(invitation_token.invitation_set).to be_an(InvitationSet)
    end
  end

  describe 'expires_at' do
    it 'should not be able to be nil' do
      invitation_token = FactoryBot.build(:invitation_token, expires_at: nil)
      expect(invitation_token.valid?).to be_falsey
      expect(invitation_token.errors.messages).to have_key :expires_at
      expect(invitation_token.errors.messages[:expires_at]).to include('moet opgegeven zijn')
    end
    it 'should be able to set it to a value' do
      invitation_token = FactoryBot.create(:invitation_token, expires_at: 14.days.from_now.in_time_zone)
      expect(invitation_token.expires_at).to be_within(1.minute).of(14.days.from_now.in_time_zone)
    end
  end

  describe 'timestamps' do
    it 'should have timestamps for created objects' do
      invitation_token = FactoryBot.create(:invitation_token)
      expect(invitation_token.created_at).to be_within(1.minute).of(Time.zone.now)
      expect(invitation_token.updated_at).to be_within(1.minute).of(Time.zone.now)
    end
  end

  describe 'expired?' do
    it 'should return false if the connected response is not expired' do
      invitation_token = FactoryBot.create(:invitation_token, expires_at: 10.days.ago)
      FactoryBot.create(:response, invitation_set: invitation_token.invitation_set)
      expect_any_instance_of(Response).to receive(:response_expired?).and_return(false)
      expect(invitation_token.expired?).to be_falsey
    end

    it 'should return false if the invitation_token is not expired' do
      invitation_token = FactoryBot.create(:invitation_token, expires_at: 10.days.from_now)
      FactoryBot.create(:response, invitation_set: invitation_token.invitation_set)
      allow_any_instance_of(Response).to receive(:response_expired?).and_return(true)
      expect(invitation_token.expired?).to be_falsey
    end

    it 'should return true if both the response and invitation token are expired' do
      invitation_token = FactoryBot.create(:invitation_token, expires_at: 10.days.ago)
      FactoryBot.create(:response, invitation_set: invitation_token.invitation_set)
      allow_any_instance_of(Response).to receive(:response_expired?).and_return(true)
      expect(invitation_token.expired?).to be_truthy
    end
  end
end
