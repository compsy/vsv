# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionnaireController, type: :controller do
  let(:person) { FactoryBot.create(:person) }
  let(:mentor) { FactoryBot.create(:mentor) }
  let(:student) { FactoryBot.create(:student) }
  describe 'GET /' do
    describe 'redirects to the correct page' do
      it 'should redirect to the questionnaire controller if the person is a student' do
        cookie_auth(student)
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  start_date: 1.week.ago.at_beginning_of_day,
                                                  person: student)
        responseobj = FactoryBot.create(:response,
                                        :invite_sent,
                                        protocol_subscription: protocol_subscription,
                                        open_from: 1.hour.ago)
        get :index
        expect(response).to have_http_status(302)
        expect(response.location).to_not eq(mentor_overview_index_url)
        expect(response.location).to eq(questionnaire_url(uuid: responseobj.uuid))
      end

      it 'should redirect to the klaar page if the person is a student but the questionnaire was completed' do
        cookie_auth(student)
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  start_date: 1.week.ago.at_beginning_of_day,
                                                  person: student)
        FactoryBot.create(:response,
                          :completed,
                          :invite_sent,
                          protocol_subscription: protocol_subscription,
                          open_from: 1.hour.ago)
        get :index
        expect(response).to have_http_status(302)
        expect(response.location).to_not eq(mentor_overview_index_url)
        expect(response.location).to eq(klaar_url)
      end

      it 'should redirect to the questionnaire controller for a mentor filling out a questionnaire for themselves' do
        cookie_auth(mentor)
        protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                  start_date: 1.week.ago.at_beginning_of_day,
                                                  person: mentor)
        responseobj = FactoryBot.create(:response, :invite_sent, protocol_subscription: protocol_subscription,
                                                                 open_from: 1.hour.ago)
        get :index
        expect(response).to have_http_status(302)
        expect(response.location).to_not eq(mentor_overview_index_url)
        expect(response.location).to eq(questionnaire_url(uuid: responseobj.uuid))
      end

      it 'should redirect to the mentor controller for a mentor filling out a questionnaire for someone else' do
        cookie_auth(mentor)
        FactoryBot.create(:protocol_subscription,
                          start_date: 1.week.ago.at_beginning_of_day,
                          person: mentor,
                          filling_out_for: FactoryBot.create(:student))
        get :index
        expect(response).to have_http_status(302)
        expect(response.location).to eq(mentor_overview_index_url)
      end
    end
  end

  describe 'GET /:uuid' do
    before :each do
      cookie_auth(person)
    end
    it 'shows status 200 when everything is correct' do
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                person: person)
      responseobj = FactoryBot.create(:response, protocol_subscription: protocol_subscription, open_from: 1.hour.ago)
      get :show, params: { uuid: responseobj.uuid }
      expect(response).to have_http_status(200)
      expect(response).to render_template('questionnaire/show')
    end

    it 'should show an informed questionnaire if there is one required' do
      protocol = FactoryBot.create(:protocol, :with_informed_consent_questionnaire)
      expect(protocol.informed_consent_questionnaire).not_to be_nil
      expect(protocol.informed_consent_questionnaire.title).to eq 'Informed Consent'
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                person: person,
                                                protocol: protocol)
      responseobj = FactoryBot.create(:response, protocol_subscription: protocol_subscription, open_from: 1.hour.ago)
      get :show, params: { uuid: responseobj.uuid }
      expect(response).to have_http_status(200)
      expect(response).to render_template('questionnaire/informed_consent')
    end

    it 'should save the response in the database, with the correct timestamp' do
      cookie_auth(mentor)
      protocol_subscription = FactoryBot.create(:protocol_subscription,
                                                start_date: 1.week.ago.at_beginning_of_day,
                                                person: mentor,
                                                filling_out_for: person)
      responseobj = FactoryBot.create(:response, protocol_subscription: protocol_subscription, open_from: 1.hour.ago)
      date = Time.zone.now
      Timecop.freeze(date)
      expect(responseobj.opened_at).to be_nil
      get :show, params: { uuid: responseobj.uuid }
      responseobj.reload
      expect(responseobj.opened_at).to be_within(5.seconds).of(date)
      Timecop.return
    end
  end

  describe 'the @is_mentor_variable' do
    let(:protocol) { FactoryBot.create(:protocol) }
    let(:protocol_subscription) do
      FactoryBot.create(:protocol_subscription,
                        start_date: 1.week.ago.at_beginning_of_day,
                        protocol: protocol)
    end
    let(:responseobj) do
      FactoryBot.create(:response, protocol_subscription: protocol_subscription,
                                   open_from: 1.hour.ago)
    end

    # let(:invitation_token) { FactoryBot.create(:invitation_token, response: responseobj) }
    it 'should set it to true when the current person is a mentor' do
      cookie_auth(mentor)
      protocol_subscription.update_attributes!(person: mentor)
      get :show, params: { uuid: responseobj.uuid }
      expect(assigns(:use_mentor_layout)).to_not be_nil
      expect(assigns(:use_mentor_layout)).to be_truthy
    end

    it 'should set it to false when the current person is a student' do
      cookie_auth(student)
      protocol_subscription.update_attributes!(person: student)
      get :show, params: { uuid: responseobj.uuid }
      expect(assigns(:use_mentor_layout)).to_not be_nil
      expect(assigns(:use_mentor_layout)).to be_falsey
    end
  end

  describe 'POST /' do
    describe 'redirecting with a student' do
      before :each do
        cookie_auth(student)
      end
      it 'requires a response id' do
        post :create
        expect(response).to have_http_status(401)
        expect(response.body).to include('Je hebt geen toegang tot deze vragenlijst.')
      end

      it 'requires a response that exists' do
        expect_any_instance_of(described_class).to receive(:verify_cookie)
        post :create, params: { response_id: 'something', content: { 'v1' => 'true' } }
        expect(response).to have_http_status(404)
        expect(response.body).to include('De vragenlijst kon niet gevonden worden.')
      end

      it 'requires a response that is not filled out yet' do
        responseobj = FactoryBot.create(:response, :completed)
        expect_any_instance_of(described_class).to receive(:verify_cookie)
        post :create, params: { response_id: responseobj.id, content: { 'v1' => 'true' } }
        expect(response).to have_http_status(302)
        expect(response.location).to eq klaar_url
      end

      it 'requires a q parameter that is not expired' do
        responseobj = FactoryBot.create(:response)
        expect_any_instance_of(described_class).to receive(:verify_cookie)
        post :create, params: { response_id: responseobj.id, content: { 'v1' => 'true' } }
        expect(response).to have_http_status(302)
        expect(response.location).to eq klaar_url
      end

      it 'shows status 200 when everything is correct' do
        expect_any_instance_of(described_class).to receive(:verify_cookie)
        protocol_subscription = FactoryBot.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
        responseobj = FactoryBot.create(:response, protocol_subscription: protocol_subscription, open_from: 1.hour.ago)
        post :create, params: { response_id: responseobj.id, content: { 'v1' => 'true' } }
        expect(response).to have_http_status(302)
        responseobj.reload
        expect(responseobj.completed_at).to be_within(1.minute).of(Time.zone.now)
        expect(responseobj.content).to_not be_nil
        expect(responseobj.values).to eq('v1' => 'true')
      end
    end

    describe 'redirecting with mentor' do
      let(:protocol_subscription) do
        FactoryBot.create(:protocol_subscription,
                          start_date: 1.week.ago.at_beginning_of_day)
      end
      let(:responseobj) do
        FactoryBot.create(:response,
                          protocol_subscription: protocol_subscription,
                          open_from: 1.hour.ago)
      end

      before :each do
        expect_any_instance_of(described_class).to receive(:verify_cookie)
        cookie_auth(mentor)
      end

      it 'should redirect to the mentor overview page if the person is a mentor filling out for him/herself' do
        protocol_subscription = FactoryBot.create(:protocol_subscription, person: mentor,
                                                                          filling_out_for: mentor,
                                                                          start_date: 1.week.ago.at_beginning_of_day)
        responseobj = FactoryBot.create(:response, protocol_subscription: protocol_subscription,
                                                   open_from: 1.hour.ago)

        post :create, params: { response_id: responseobj.id, content: { 'v1' => 'true' } }
        expect(response).to have_http_status(302)
        expect(response.location).to eq mentor_overview_index_url
      end

      it 'should redirect to the mentor overview page if the person is a mentor filling out for someone else' do
        protocol_subscription = FactoryBot.create(:protocol_subscription, person: mentor,
                                                                          filling_out_for: student,
                                                                          start_date: 1.week.ago.at_beginning_of_day)
        responseobj = FactoryBot.create(:response, protocol_subscription: protocol_subscription,
                                                   open_from: 1.hour.ago)

        post :create, params: { response_id: responseobj.id, content: { 'v1' => 'true' } }
        expect(response).to have_http_status(302)
        expect(response.location).to eq mentor_overview_index_url
      end
    end

    context 'saving response in the database' do
      let!(:protocol_subscription) do
        FactoryBot.create(:protocol_subscription,
                          start_date: 1.week.ago.at_beginning_of_day,
                          person: mentor,
                          filling_out_for: student)
      end

      let!(:responseobj) do
        FactoryBot.create(:response, protocol_subscription: protocol_subscription, open_from: 1.hour.ago)
      end

      before :each do
        cookie_auth(mentor)
        expect_any_instance_of(described_class).to receive(:verify_cookie)
      end

      it 'should save the response in the database, with the filled out by and for' do
        expect(responseobj.filled_out_by).to be_nil
        expect(responseobj.filled_out_for).to be_nil
        post :create, params: { response_id: responseobj.id, content: { 'v1' => 'true' } }
        responseobj.reload
        expect(responseobj.filled_out_by).to eq mentor
        expect(responseobj.filled_out_for).to eq student
      end
    end
  end
end
