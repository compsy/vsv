# frozen_string_literal: true

require 'rails_helper'

describe SendInvitations do
  describe 'run' do
    it 'should call the recently_opened_and_not_sent scope' do
      expect(Response).to receive(:recently_opened_and_not_sent).and_return []
      described_class.run
    end

    describe 'loops through responses' do
      it 'should queue recent responses' do
        protocol_subscription = FactoryGirl.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
        response = FactoryGirl.create(:response, open_from: 1.hour.ago, protocol_subscription: protocol_subscription)
        expect(SendInvitationJob).to receive(:perform_later).with(response).and_return true
        described_class.run
        response.reload
        expect(response.invited_state).to eq(Response::SENDING_STATE)
      end

      it 'should not queue a response that is expired' do
        protocol_subscription = FactoryGirl.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
        response = FactoryGirl.create(:response, open_from: 3.hour.ago, protocol_subscription: protocol_subscription)
        expect(SendInvitationJob).not_to receive(:perform_later)
        described_class.run
        response.reload
        expect(response.invited_state).to eq(Response::NOT_SENT_STATE)
      end

      it 'should not queue a response from an inactive protocol subscription' do
        protocol_subscription = FactoryGirl.create(:protocol_subscription,
                                                   state: ProtocolSubscription::CANCELED_STATE,
                                                   start_date: 1.week.ago.at_beginning_of_day)
        response = FactoryGirl.create(:response, open_from: 1.hour.ago, protocol_subscription: protocol_subscription)
        expect(SendInvitationJob).not_to receive(:perform_later)
        described_class.run
        response.reload
        expect(response.invited_state).to eq(Response::NOT_SENT_STATE)
      end
    end

    describe 'reminders' do
      it 'should queue recent responses' do
        protocol_subscription = FactoryGirl.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
        measurement = FactoryGirl.create(:measurement, open_duration: 1.day, protocol: protocol_subscription.protocol)
        response = FactoryGirl.create(:response, open_from: 9.hours.ago,
                                                 protocol_subscription: protocol_subscription,
                                                 invited_state: Response::SENT_STATE,
                                                 measurement: measurement)
        expect(SendInvitationJob).to receive(:perform_later).with(response).and_return true
        described_class.run
        response.reload
        expect(response.invited_state).to eq(Response::SENDING_REMINDER_STATE)
      end

      it 'should not queue a response that is expired' do
        protocol_subscription = FactoryGirl.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
        response = FactoryGirl.create(:response, open_from: 9.hours.ago,
                                                 protocol_subscription: protocol_subscription,
                                                 invited_state: Response::SENT_STATE)
        expect(SendInvitationJob).not_to receive(:perform_later)
        described_class.run
        response.reload
        expect(response.invited_state).to eq(Response::SENT_STATE)
      end

      it 'should not queue a response outside the 2 hour reminder window' do
        protocol_subscription = FactoryGirl.create(:protocol_subscription, start_date: 1.week.ago.at_beginning_of_day)
        measurement = FactoryGirl.create(:measurement, open_duration: 1.day, protocol: protocol_subscription.protocol)
        response = FactoryGirl.create(:response, open_from: 11.hours.ago,
                                                 protocol_subscription: protocol_subscription,
                                                 invited_state: Response::SENT_STATE,
                                                 measurement: measurement)
        expect(SendInvitationJob).not_to receive(:perform_later)
        described_class.run
        response.reload
        expect(response.invited_state).to eq(Response::SENT_STATE)
      end

      it 'should not queue a response from an inactive protocol subscription' do
        protocol_subscription = FactoryGirl.create(:protocol_subscription,
                                                   start_date: 1.week.ago.at_beginning_of_day,
                                                   state: ProtocolSubscription::CANCELED_STATE)
        measurement = FactoryGirl.create(:measurement, open_duration: 1.day, protocol: protocol_subscription.protocol)
        response = FactoryGirl.create(:response, open_from: 9.hours.ago,
                                                 protocol_subscription: protocol_subscription,
                                                 invited_state: Response::SENT_STATE,
                                                 measurement: measurement)
        expect(SendInvitationJob).not_to receive(:perform_later)
        described_class.run
        response.reload
        expect(response.invited_state).to eq(Response::SENT_STATE)
      end
    end
  end
end
