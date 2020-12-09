# frozen_string_literal: true

class QuestionnaireController < ApplicationController
  include QuestionnaireHelper
  MAX_ANSWER_LENGTH = 2048
  MAX_DRAWING_LENGTH = 65_536
  include Concerns::IsLoggedIn
  protect_from_forgery prepend: true, with: :exception, except: :create
  skip_before_action :verify_authenticity_token, only: %i[interactive_render from_json]
  before_action :log_csrf_error, only: %i[create]
  before_action :set_response, only: %i[show preference destroy]
  before_action :set_locale, only: %i[show]
  # TODO: verify cookie for show as well
  before_action :store_response_cookie, only: %i[show]
  before_action :verify_cookie, only: %i[create create_informed_consent]
  before_action :set_layout, only: [:show]
  before_action :check_informed_consent, only: [:show]
  before_action :set_questionnaire_content, only: [:show]
  before_action :set_create_response, only: %i[create create_informed_consent]
  before_action :check_opened_at, only: [:create]
  before_action :check_content_empty, only: [:create]
  before_action :check_content_hash, only: [:create]
  before_action :check_interactive_content, only: %i[interactive_render]
  before_action :set_interactive_content, only: %i[interactive_render]
  before_action :verify_interactive_content, only: %i[interactive_render]
  before_action :set_default_content, only: %i[interactive]

  def index
    redirect_to NextPageFinder.get_next_page current_user: current_user
  end

  # Allows users to be redirected to the correct questionnaire with preference
  # for a certain response
  def preference
    redirect_to NextPageFinder.get_next_page current_user: current_user, next_response: @response
  end

  def interactive; end

  # This method is used to post results from the interactive questionnaire previewer
  def from_json
    flash[:success] = 'Success! If this were an actual questionnaire, your response would have been saved.'
    redirect_to :interactive_questionnaire_index
  end

  def interactive_render
    @content = QuestionnaireGenerator.new.generate_questionnaire(
      response_id: nil,
      content: @raw_questionnaire_content,
      title: 'Test questionnaire',
      submit_text: (Rails.application.config.i18n.default_locale.to_s == 'en' ? 'Save' : 'Opslaan'),
      action: '/questionnaire/from_json',
      unsubscribe_url: nil,
      locale: Rails.application.config.i18n.default_locale.to_s
    )

    render 'questionnaire/show', layout: nil
  end

  def show
    @response.update!(opened_at: Time.zone.now)
  end

  def create_informed_consent
    @protocol_subscription.informed_consent_given_at = Time.zone.now
    @protocol_subscription.save!
    @response.update!(opened_at: Time.zone.now)
    redirect_to questionnaire_path(uuid: @response.uuid)
  end

  def create
    complete_response
    check_stop_subscription
    if @response.measurement.collapse_duplicates?
      orig_response = @response
      was_canceled = orig_response.protocol_subscription.canceled?
      orig_response.collapsible_duplicates.each do |response|
        # we have to override @response because it is used everywhere
        @response = response
        # Set the opened at to the same time as the original response
        @response.update!(opened_at: orig_response.opened_at)
        complete_response
        # if the original response canceled the protocol subscription, so should this one
        # (because if it is the same measurement, it is also a stop measurement).
        # We call stop_protocol_subscription instead of check_protocol_subscription, because
        # the latter performs a check on a hash in the response_contents with the id of the response,
        # which wouldn't match.
        stop_protocol_subscription if was_canceled
      end
      @response = orig_response
    end
    redirect_to questionnaire_create_params[:callback_url] || NextPageFinder.get_next_page(current_user: current_user,
                                                                                           previous_response: @response)
  end

  def destroy
    stop_response = @protocol_subscription.stop_response

    if stop_response.nil?
      stop_protocol_subscription
      return
    end

    # Note, we don't unsubscribe yet. If a person clicks the 'stop' link, the
    # person is redirected to the stop questionnaire. However, as long as the
    # student does not submit that questionnaire, he or she is not unsubscribed
    redirect_to NextPageFinder.get_next_page current_user: current_user, next_response: stop_response
  end

  private

  def complete_response
    response_content = ResponseContent.create_with_scores!(content: questionnaire_content, response: @response)
    @response.update!(content: response_content.id)
    @response.complete!
  end

  def set_locale
    person = current_user
    I18n.locale = if person
                    person.locale
                  else
                    I18n.default_locale
                  end
  end

  def check_interactive_content
    return unless params.blank? || params[:content].blank?

    render(status: :bad_request, json: { error: 'Please supply a json string in the content field.' })
  end

  def set_interactive_content
    @raw_questionnaire_content = JSON.parse(params[:content])
    ensure_content_is_hash!
    return if performed?

    make_content_indifferent!
  rescue JSON::ParserError => e
    render status: :bad_request, json: { error: e.message }
  rescue TypeError => e
    render status: :bad_request, json: { error: e.message }
  end

  def ensure_content_is_hash!
    if @raw_questionnaire_content.blank?
      render status: :bad_request, json: { error: 'At least one question should be provided' }
      return
    end
    if !(@raw_questionnaire_content.is_a? Hash) && @raw_questionnaire_content.is_a?(Array)
      @raw_questionnaire_content = { questions: @raw_questionnaire_content, scores: [] }
    end
    return if @raw_questionnaire_content.is_a? Hash

    render status: :bad_request, json: { error: 'questions should be in an array or hash' }
  end

  def make_content_indifferent!
    @raw_questionnaire_content = @raw_questionnaire_content.with_indifferent_access
    unless @raw_questionnaire_content.key?(:scores) && @raw_questionnaire_content.key?(:questions)
      render status: :bad_request, json: { error: 'The given hash should have the :questions and :scores attributes' }
      return
    end
    @raw_questionnaire_content[:questions] = @raw_questionnaire_content[:questions].map(&:with_indifferent_access)
    @raw_questionnaire_content[:scores] = @raw_questionnaire_content[:scores].map(&:with_indifferent_access)
  end

  # This cop changes the code to not work anymore:
  # rubocop:disable Style/WhileUntilModifier
  def verify_interactive_content
    key = random_string
    while Questionnaire.find_by(key: key)
      key = random_string
    end
    questionnaire = Questionnaire.new(name: key, key: key, content: @raw_questionnaire_content)
    return if questionnaire.valid?

    render status: :bad_request, json: { error: questionnaire.errors }
  end
  # rubocop:enable Style/WhileUntilModifier

  def random_string
    (0...10).map { ('a'..'z').to_a[rand(26)] }.join
  end

  def check_stop_subscription
    # We assume that if a stop measurement is submitted, it is always the last
    # questionnaire of the protocol.
    return stop_protocol_subscription if @response.measurement.stop_measurement?

    stop_subscription_hash = questionnaire_stop_subscription
    content = questionnaire_content
    return if stop_subscription_hash.blank?

    # NOTE: When a questionnaire has a "stop subscription" question, it bypasses the
    #       stop measurement (i.e., the protocol subscription will be stopped without
    #       requiring its stop measurement to be filled out). So only use "stop subscription"
    #       questions in protocols that don't have a stop_measurement. (Maybe check this
    #       in model validations).
    should_stop = false
    stop_subscription_hash.each do |key, received|
      next unless content.key?(key)

      expected = Response.stop_subscription_token(key, content[key], @response.id)
      if ActiveSupport::SecurityUtils.secure_compare(expected, received)
        should_stop = true
        break
      end
    end
    return unless should_stop

    stop_protocol_subscription
  end

  def stop_protocol_subscription
    @response.protocol_subscription.cancel!
    check_to_send_confirmation_email if ENV['PROJECT_NAME'] == 'Evaluatieonderzoek'
    # If we have a callback_url, we will redirect to it, which means the flash hash is never read out
    # until the next time that we fill out a questionnaire, and then it says "thanks for unsubscribing", which is weird.
    # Hence, don't set a flash notice if we have a callback_url.
    flash[:notice] = stop_protocol_subscription_notice unless params[:callback_url].present?
    Rails.logger.info "[Info] Protocol subscription #{@response.protocol_subscription.id} was stopped by " \
      "person #{@response.protocol_subscription.person_id}."
  end

  def stop_protocol_subscription_notice
    if @response.protocol_subscription.mentor?
      "Succes: De begeleiding voor #{@response.protocol_subscription.filling_out_for.first_name} " \
                         'is gestopt.'
    elsif @response.protocol_subscription.person.role.group == Person::SOLO
      I18n.t('pages.klaar.header')
    else
      "Je hebt je uitgeschreven voor het #{Rails.application.config.settings.application_name} onderzoek."\
        ' Bedankt voor je inzet!'
    end
  end

  def check_content_hash
    drawing_ids = @response.measurement.questionnaire.drawing_ids
    questionnaire_content.each do |key, value|
      next if answer_within_limits?(key, value)

      next if drawing_within_limits?(key, value, drawing_ids)

      render(status: :bad_request, html: 'Het antwoord is te lang en kan daardoor niet worden opgeslagen',
             layout: 'application')
      break
    end
  end

  def check_content_empty
    quest_content = questionnaire_content
    return if quest_content.present? && (quest_content.keys - [Response::CSRF_FAILED]).present?

    render(status: :bad_request, html: 'Cannot store blank questionnaire responses', layout: 'application')
  end

  def check_opened_at
    return if @response.opened_at.present?

    render(status: :bad_request, html: 'Cannot accept answers for an unopened response',
           layout: 'application')
  end

  def check_informed_consent
    render :informed_consent if @protocol_subscription.needs_informed_consent?
  end

  def verify_cookie
    return if AuthenticationVerifier.valid? questionnaire_create_params[:response_id], current_user

    render(status: :unauthorized, html: 'Je hebt geen toegang tot deze vragenlijst.', layout: 'application')
  end

  def set_response
    the_response = current_user.all_my_open_responses(nil)
                               .find { |response| response.uuid == questionnaire_params[:uuid] }

    check_response(the_response)
    return if performed?

    @response = the_response
    set_protocol_and_subscription
  end

  def set_create_response
    @response = Response.find_by(id: questionnaire_create_params[:response_id])
    check_response(@response)
    return if performed?

    # Now that we know the response can be filled out, update the cookies so the redirect works as expected.
    store_response_cookie
    set_protocol_and_subscription
  end

  def set_protocol_and_subscription
    @protocol_subscription = @response.protocol_subscription
    @protocol = @protocol_subscription.protocol
  end

  def set_questionnaire_content
    @content = QuestionnaireGenerator.new.generate_questionnaire(
      response_id: @response.id,
      content: @response.measurement.questionnaire.content,
      title: @response.measurement.questionnaire.title,
      submit_text: (@response.person.locale == 'en' ? 'Save' : 'Opslaan'),
      action: '/',
      unsubscribe_url: @response.unsubscribe_url,
      locale: @response.person.locale,
      params: default_questionnaire_params
    )
  end

  def default_questionnaire_params
    {
      authenticity_token: form_authenticity_token(form_options: { action: '/', method: 'post' }),
      callback_url: questionnaire_params[:callback_url]
    }
  end

  def questionnaire_params
    params.permit(:uuid, :method, :callback_url)
  end

  def questionnaire_create_params
    # TODO: change the below line to the following in rails 5.1:
    # params.permit(:response_id, content: {})
    params.permit(:response_id,
                  :callback_url,
                  content: permit_recursive_params(params[:content]&.to_unsafe_h),
                  stop_subscription: permit_recursive_params(params[:stop_subscription]&.to_unsafe_h))
  end

  def questionnaire_content
    return {} if questionnaire_create_params[:content].nil?

    questionnaire_create_params[:content].to_unsafe_h
  end

  def questionnaire_stop_subscription
    return {} if questionnaire_create_params[:stop_subscription].nil?

    questionnaire_create_params[:stop_subscription].to_unsafe_h
  end

  def store_response_cookie
    cookie = { TokenAuthenticationController::RESPONSE_ID_COOKIE => @response.id.to_s }
    CookieJar.set_or_update_cookie(cookies.signed, cookie)
  end

  def set_layout
    @use_mentor_layout = @response.protocol_subscription.person.mentor? || @response.protocol_subscription.person.solo?
  end

  def check_response(response)
    unless response
      render(status: :not_found, html: 'De vragenlijst kon niet gevonden worden.', layout: 'application')
      return
    end

    # Instead of throwing a 404, just redirect to the next page in line if one is already completed.
    if response.completed_at
      redirect_to NextPageFinder.get_next_page current_user: current_user
      return
    end

    # A person should always be able to fill out a stop measurement
    return if !response.expired? || response.measurement.stop_measurement

    flash[:notice] = 'Deze vragenlijst kan niet meer ingevuld worden.'
    redirect_to NextPageFinder.get_next_page current_user: current_user
  end

  def log_csrf_error
    return unless protect_against_forgery? # is false in test environment
    return if valid_request_origin? && any_authenticity_token_valid?

    record_warning_in_rails_logger
    params['content'][Response::CSRF_FAILED] = 'true' if params['content'].present?
  end

  def record_warning_in_rails_logger
    Rails.logger.warn "[Attention] CSRF error for user #{current_user&.id} at " \
                      "#{request.fullpath} with params: #{params.pretty_inspect}"
  end

  def drawing_within_limits?(key, value, drawing_ids)
    key.to_s.size <= MAX_ANSWER_LENGTH && drawing_ids.include?(key.to_sym) && value.to_s.size <= MAX_DRAWING_LENGTH
  end

  def answer_within_limits?(key, value)
    key.to_s.size <= MAX_ANSWER_LENGTH && value.to_s.size <= MAX_ANSWER_LENGTH
  end

  def set_default_content
    @default_content = ''
    @default_content = Base64.strict_decode64(params['content']) if params['content']
  rescue ArgumentError => e
    # Check if the parsing was wrong, if it was, we don't do anything. If it was something else, reraise.
    raise e if e.message != 'invalid base64'
  end
end
