# frozen_string_literal: true

module Api
  module V1
    module JwtApi
      class ResponseController < JwtApiController
        before_action :set_person, only: %i[show index completed]
        before_action :set_response, only: %i[show create]
        before_action :set_responses, only: %i[index]
        before_action :set_completed_responses, only: %i[completed]
        before_action :check_empty_response, only: %i[create]

        def show
          render json: @response, serializer: Api::PersonalizedQuestionnaireSerializer
        end

        def index
          render json: @responses, each_serializer: Api::ResponseSerializer
        end

        def create
          content = ResponseContent.create!(content: response_content)
          @response.update!(content: content.id)
          @response.complete!
          head 201
        end

        def completed
          render json: @responses, each_serializer: Api::ResponseSerializer
        end

        private

        def set_person
          # Debugging
          # token = request.headers['Authorization'].split.last
          # Rails.logger.warn Knock::AuthToken.new(token: token)
          # Rails.logger.warn current_auth_user.person.inspect

          @person = current_auth_user&.person
          return if @person.present?

          result = { result: current_auth_user.to_json }
          render(status: :not_found, json: result)
        end

        def set_completed_responses
          @responses = @person.my_completed_responses
          return if @responses.present?

          result = { result: 'Geen completed responses voor deze persoon gevonden' }
          render(status: :not_found, json: result)
        end

        def set_responses
          @responses = @person.my_open_responses
          return if @responses.present?

          result = { result: 'Geen responses voor deze persoon gevonden' }
          render(status: :not_found, json: result)
        end

        def set_response
          @response = current_auth_user.person.responses.find_by(uuid: response_params[:uuid])
          return if @response.present?

          result = { result: 'Response met dat uuid niet gevonden' }
          render(status: :not_found, json: result)
        end

        def check_empty_response
          return if @response.content.blank?

          result = { result: 'Response met dat uuid heeft al content' }
          render(status: :bad_request, json: result)
        end

        def response_content
          return {} if response_params[:content].nil?

          response_params[:content].to_unsafe_h
        end

        def response_params
          # TODO: change the below line to the following in rails 5.1:
          # params.permit(:response_id, content: {})
          params.permit(:external_identifier, :uuid, content: permit_recursive_params(params[:content]&.to_unsafe_h))
        end
      end
    end
  end
end