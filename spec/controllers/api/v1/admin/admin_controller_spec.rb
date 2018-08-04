# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::Admin::AdminApiController, type: :controller do
  let!(:the_auth_user) { FactoryBot.create(:auth_user, :admin) }
  controller do
    def dummy
      render plain: 'dummy called'
    end
  end

  before do
    routes.draw { get 'dummy' => 'api/v1/admin/admin_api#dummy' }
  end

  it_should_behave_like 'a jwt authenticated route', 'get', :dummy

  it 'should raise 403 if we are not an admin user' do
    jwt_auth(sub: FactoryBot.create(:auth_user).auth0_id_string)
    get :dummy
    expect(response.status).to eq 403
    expect(response.body).to_not be_nil

    expected = { result: 'Not implemented, check if the user has the correct role' }.to_json
    expect(response.body).to eq expected
  end
end
