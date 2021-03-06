# frozen_string_literal: true

module Api
  module V1
    module BasicAuthApi
      class QuestionnairesController < BasicAuthApiController
        include QuestionnaireCreateHelper

        def create
          create_questionnaire
        end
      end
    end
  end
end
