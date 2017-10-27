# frozen_string_literal: true

require 'rails_helper'

describe Organization, type: :model do
  describe 'validations' do
    it 'should be valid by default' do
      organization = FactoryGirl.create(:organization)
      expect(organization).to be_valid
    end

    describe 'name' do
      it 'should be invalid when not present' do
        organization = FactoryGirl.build(:organization, name: nil)
        expect(organization).to_not be_valid
        organization = FactoryGirl.build(:organization, name: 'test name')
        expect(organization).to be_valid
      end

      it 'should be invalid when not unique' do
        FactoryGirl.create(:organization, name: 'test')
        organization2 = FactoryGirl.build(:organization, name: 'test')
        expect(organization2).to_not be_valid
      end
    end
  end

  it 'should be able to retrieve roles' do
    organization = FactoryGirl.create(:organization, :with_roles)
    expect(organization.roles.to_a).to be_a(Array)
    organization.roles.each do |role|
      expect(role).to be_a(Role)
    end
  end
end
