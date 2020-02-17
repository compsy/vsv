# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin, type: :model do
  let!(:admin) { FactoryBot.create(:admin) }
  let!(:admin2) { FactoryBot.create(:admin) }

  describe 'validations' do
    it 'has a valid factory' do
      expect(FactoryBot.create(:admin)).to be_valid
    end
    describe 'auth0_id_string' do
      it 'validates the uniqueness of the auth0_id_string' do
        admin.auth0_id_string = admin2.auth0_id_string
        expect(admin).not_to be_valid
      end

      it 'validates the presence of the auth0_id_string' do
        admin.auth0_id_string = nil
        expect(admin).not_to be_valid
      end
    end
  end

  describe 'from_token_payload' do
    it 'creates a new admin from the token payload' do
      pre = Admin.count
      payload = { described_class::AUTH0_KEY_LOCATION => '1234' }
      result = Admin.from_token_payload(payload)
      post = Admin.count
      expect(post).to eq pre + 1
      expect(result).to be_an Admin
      expect(result.auth0_id_string).to eq payload[described_class::AUTH0_KEY_LOCATION]
    end

    it 'does not create a new admin when one with the same auth0_id_string already exists' do
      payload = { described_class::AUTH0_KEY_LOCATION => admin.auth0_id_string }
      pre = Admin.count
      result = Admin.from_token_payload(payload)
      post = Admin.count

      expect(post).to eq pre
      expect(result).to be_an Admin
      expect(result.auth0_id_string).to eq payload[described_class::AUTH0_KEY_LOCATION]
    end

    it 'raises if the payload is misspecified' do
      payload = { 'something' => '1234' }
      pre = Admin.count
      expect { Admin.from_token_payload(payload) }.to raise_error(RuntimeError, "Invalid payload #{payload}")
      post = Admin.count
      expect(post).to eq pre
    end
  end
end