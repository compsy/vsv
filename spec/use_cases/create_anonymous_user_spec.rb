# frozen_string_literal: true

require 'rails_helper'

describe CreateAnonymousUser do
  describe 'with a role_title specified' do
    let!(:team) { FactoryBot.create(:team, :with_roles, name: 'Teamname') }
    let(:auth0_id_string) { 'hoi' }
    let(:role_title) { 'Studenttitle' }
    let(:access_level) { AuthUser::USER_ACCESS_LEVEL }

    it 'creates a new auth user and person with the correct properties' do
      pre_count = Person.count
      pre_acount = AuthUser.count
      auth_user = described_class.run!(auth0_id_string: auth0_id_string,
                                       team_name: team.name,
                                       role_title: role_title,
                                       access_level: access_level)
      expect(AuthUser.count).to eq(pre_acount + 1)
      expect(Person.count).to eq(pre_count + 1)
      expect(auth_user).to be_valid
      expect(auth_user.auth0_id_string).to eq auth0_id_string
      expect(auth_user.access_level).to eq access_level
      expect(auth_user.person.first_name).to eq auth0_id_string
      expect(auth_user.person.last_name).to eq auth0_id_string
      expect(auth_user.person.auth_user).to eq auth_user
      expect(auth_user.person.role.title).to eq role_title
    end

    it 'reuses the existing auth_user and person if they exist' do
      role = team.roles.where(title: role_title).first
      person = FactoryBot.create(:person, first_name: auth0_id_string, last_name: auth0_id_string, role: role)
      auth_user = FactoryBot.create(:auth_user, auth0_id_string: auth0_id_string, person: person)
      person.reload
      pre_count = Person.count
      pre_acount = AuthUser.count
      auth_user2 = described_class.run!(auth0_id_string: auth0_id_string,
                                        team_name: team.name,
                                        role_title: role_title,
                                        access_level: access_level)
      expect(AuthUser.count).to eq(pre_acount)
      expect(Person.count).to eq(pre_count)
      expect(auth_user2).to eq auth_user
      expect(auth_user).to be_valid
      expect(auth_user.auth0_id_string).to eq auth0_id_string
      expect(auth_user.access_level).to eq access_level
      expect(auth_user.person.first_name).to eq auth0_id_string
      expect(auth_user.person.last_name).to eq auth0_id_string
      expect(auth_user.person.auth_user).to eq auth_user
      expect(auth_user.person.role.title).to eq role_title
    end
  end

  describe 'without a role_title specified' do
    let!(:team) { FactoryBot.create(:team, :with_roles, name: 'Teamname') }
    let(:auth0_id_string) { 'hoi' }
    let(:role_title) { 'Studenttitle' }
    let(:access_level) { AuthUser::USER_ACCESS_LEVEL }

    it 'creates a new auth user and person with the correct properties' do
      pre_count = Person.count
      pre_acount = AuthUser.count
      auth_user = described_class.run!(auth0_id_string: auth0_id_string,
                                       team_name: team.name,
                                       access_level: access_level)
      expect(AuthUser.count).to eq(pre_acount + 1)
      expect(Person.count).to eq(pre_count + 1)
      expect(auth_user).to be_valid
      expect(auth_user.auth0_id_string).to eq auth0_id_string
      expect(auth_user.access_level).to eq access_level
      expect(auth_user.person.first_name).to eq auth0_id_string
      expect(auth_user.person.last_name).to eq auth0_id_string
      expect(auth_user.person.auth_user).to eq auth_user
      expect(auth_user.person.role.title).to eq role_title
    end

    it 'reuses the existing auth_user and person if they exist' do
      role = team.roles.where(title: role_title).first
      person = FactoryBot.create(:person, first_name: auth0_id_string, last_name: auth0_id_string, role: role)
      auth_user = FactoryBot.create(:auth_user, auth0_id_string: auth0_id_string, person: person)
      person.reload
      pre_count = Person.count
      pre_acount = AuthUser.count
      auth_user2 = described_class.run!(auth0_id_string: auth0_id_string,
                                        team_name: team.name,
                                        access_level: access_level)
      expect(AuthUser.count).to eq(pre_acount)
      expect(Person.count).to eq(pre_count)
      expect(auth_user2).to eq auth_user
      expect(auth_user).to be_valid
      expect(auth_user.auth0_id_string).to eq auth0_id_string
      expect(auth_user.access_level).to eq access_level
      expect(auth_user.person.first_name).to eq auth0_id_string
      expect(auth_user.person.last_name).to eq auth0_id_string
      expect(auth_user.person.auth_user).to eq auth_user
      expect(auth_user.person.role.title).to eq role_title
    end
  end
end