# frozen_string_literal: true

require 'rails_helper'

module Api
  module V1
    module Admin
      describe OrganizationController, type: :controller do
        it_should_behave_like 'a jwt authenticated route', :show, group: Person::STUDENT
        it_should_behave_like 'a jwt authenticated route', :show, group: Person::MENTOR
        describe '#show' do
          let(:week_number) { '1' }
          let(:year) { '2018' }
          let(:group) {  Person::STUDENT }
          let(:overview) { Organization.organization_overview }
          let(:admin) { FactoryGirl.create(:admin) }

          before :each do
            payload = { sub: admin.auth0_id_string }
            jwt_auth payload
          end

          it 'should call the render function with the correct parameters' do
            expect(Organization).to receive(:organization_overview)
              .with(week_number, year)
              .and_return(overview)

            expect(controller).to receive(:render)
              .with(json: overview,
                    serializer: Api::OrganizationOverviewSerializer,
                    group: group)
              .and_call_original

            get :show, params: { group: group,
                                 year: year,
                                 week_number: week_number }
          end

          it 'should also work without the year and week_number parameters' do
            get :show, params: { group: Person::STUDENT }
            expect(response.status).to eq(200)
          end

          it 'should call the overview generator function and store it ' do
            expect(Organization).to receive(:organization_overview)
              .with(week_number, year)
              .and_return(overview)

            get :show, params: { group: Person::STUDENT,
                                 year: year,
                                 week_number: week_number }

            result = controller.instance_variable_get(:@organization_overview)
            expect(result).to eq(overview)
          end
        end
      end
    end
  end
end
