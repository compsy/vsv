# frozen_string_literal: true

class Person < ApplicationRecord
  include ActiveModel::Validations
  MALE = 'male'
  FEMALE = 'female'

  MENTOR = 'Mentor'
  STUDENT = 'Student'
  SOLO = 'Solo'
  OTHER = 'Other'

  DEFAULT_PERCENTAGE = 70

  IDENTIFIER_LENGTH = 4

  validates :mobile_phone,
            length: { minimum: 10, maximum: 10 },
            format: /\A\d{10}\z/,
            mobile_phone: true,
            allow_blank: true,
            uniqueness: true

  validates :email,
            format: /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
            allow_blank: true,
            uniqueness: true

  validates_with IbanValidator

  validates :external_identifier,
            format: /\A[a-z0-9]{#{IDENTIFIER_LENGTH}}\z/io,
            allow_blank: false,
            uniqueness: true
  validates :first_name, presence: true
  belongs_to :role
  validates :role_id, presence: true
  validates :gender, inclusion: { in: [MALE, FEMALE, nil] }
  has_many :protocol_subscriptions, -> { order created_at: :desc }, dependent: :destroy, inverse_of: :person
  has_many :responses, through: :protocol_subscriptions
  has_many :responses_filled_out_for_me,
           class_name: 'Response',
           dependent: :nullify,
           inverse_of: :filled_out_for,
           foreign_key: 'filled_out_for_id'
  # invitation_sets.first is the last one created:
  has_many :invitation_sets, -> { order created_at: :desc }, dependent: :destroy, inverse_of: :person
  has_one :auth_user, dependent: :destroy
  # Not used right now:
  # has_many :supervised_protocol_subscriptions,
  #          -> { order created_at: :desc },
  #          class_name: 'ProtocolSubscription', foreign_key: 'filled_out_for_id'
  has_many :children, class_name: 'Person', foreign_key: 'parent_id', dependent: :nullify, inverse_of: :parent
  belongs_to :parent, class_name: 'Person', optional: true
  validate :not_own_parent
  validates :locale, inclusion: Rails.application.config.i18n.available_locales.map(&:to_s)
  validates :account_active, inclusion: { in: [true, false] }

  after_initialize do |person|
    next if person.external_identifier

    loop do
      person.external_identifier = RandomStringGenerator.generate_alpha_numeric(Person::IDENTIFIER_LENGTH)
      break if Person.where(external_identifier: person.external_identifier).count.zero?
    end
  end

  def last_completed_response
    protocol_subscriptions.map { |x| x.responses.completed }
                          .flatten
                          .max_by(&:completed_at)
  end

  def mentor?
    role&.group == Person::MENTOR
  end

  def solo?
    role&.group == Person::SOLO
  end

  def active_protocol_subscriptions_with_stop_responses_first
    protocol_subscriptions.active.sort_by { |prot_sub| prot_sub.stop_response.blank? ? 1 : 0 }
  end

  def my_students
    return [] unless mentor? && protocol_subscriptions.present?

    protocol_subscriptions.reject { |prot_sub| prot_sub.filling_out_for_id == id }.map(&:filling_out_for)
  end

  def my_protocols(for_myself = true)
    return [] if protocol_subscriptions.active.blank?

    prot_subs = my_inactive_and_active_protocol_subscriptions.active

    filter_for_myself(prot_subs, for_myself)
  end

  def my_inactive_and_active_protocol_subscriptions
    protocol_subscriptions.joins(
      :protocol
    ).joins(
      'LEFT JOIN one_time_responses ON one_time_responses.protocol_id = protocols.id'
    ).where(one_time_responses: { id: nil })
  end

  # For any method that only returns open responses, we want them to be sorted by descending priority first,
  # and ascending open_from second. This is because we call .first on this method to determine which is the next
  # response that should be shown to the user.
  def my_open_responses(for_myself = true)
    active_subscriptions = nil
    active_subscriptions = protocol_subscriptions.active if for_myself.blank?
    active_subscriptions ||= my_protocols(for_myself)
    active_subscriptions.map { |prot| prot.responses.opened_and_not_expired }
                        .flatten
                        .reject { |response| response.protocol_subscription.protocol.otr_protocol? }
                        .sort_by(&:priority_sorting_metric)
  end

  # For any method that only returns open responses, we want them to be sorted by descending priority first,
  # and ascending open_from second. This is because we call .first on this method to determine which is the next
  # response that should be shown to the user.
  def my_open_one_time_responses(for_myself = true)
    prot_subs = protocol_subscriptions.active.joins(protocol: :one_time_responses).distinct(:id)
    subscriptions = filter_for_myself(prot_subs, for_myself)
    subscriptions.map { |prot| prot.responses.opened_and_not_expired }.flatten.sort_by(&:priority_sorting_metric)
  end

  def all_my_open_one_time_responses
    my_open_one_time_responses(nil)
  end

  # For any method that only returns open responses, we want them to be sorted by descending priority first,
  # and ascending open_from second.
  def all_my_open_responses(for_myself = true)
    (my_open_responses(for_myself) + my_open_one_time_responses(for_myself)).sort_by(&:priority_sorting_metric)
  end

  # For any method that can also return completed responses, it makes more sense to sort by open_from first.
  def my_responses
    protocol_subscriptions.map(&:responses).flatten.sort_by(&:open_from_sorting_metric)
  end

  # For any method that can also return completed responses, it makes more sense to sort by open_from first.
  def my_completed_responses
    protocol_subscriptions.map { |prot| prot.responses.completed }.flatten.sort_by(&:open_from_sorting_metric)
  end

  def open_questionnaire?(questionnaire_name)
    my_open_responses.count do |resp|
      resp.measurement.questionnaire.name == questionnaire_name
    end.positive?
  end

  def mentor
    # Introduce caching because otherwise it does a (cached) database query for every question in a questionnaire
    return @mentor if @mentorcached

    warn_for_multiple_mentors
    @mentorcached = true
    @mentor = ProtocolSubscription.active.where(filling_out_for_id: id).where.not(person_id: id).first&.person
    @mentor
  end

  def stats(week_number, year, threshold_percentage)
    person_completed = 0
    person_total = 0
    protocol_subscriptions.active.each do |subscription|
      past_week = subscription.responses.in_week(week_number: week_number, year: year)
      person_completed += past_week.completed.count || 0
      person_total += past_week.count || 0
    end
    {
      met_threshold_completion: check_threshold(person_completed, person_total, threshold_percentage),
      completed: person_completed,
      total: person_total
    }
  end

  private

  def filter_for_myself(prot_subs, for_myself)
    # Note that false is also blank (hence nil)
    return prot_subs.to_a if for_myself.nil?

    if for_myself
      prot_subs.select { |prot_sub| prot_sub.filling_out_for_id == id }
    else
      prot_subs.reject { |prot_sub| prot_sub.filling_out_for_id == id }
    end
  end

  def check_threshold(completed, total, threshold_percentage)
    return 0 unless total.positive?

    threshold_percentage ||= Person::DEFAULT_PERCENTAGE
    threshold_percentage = threshold_percentage.to_i
    actual_percentage = completed.to_d / total.to_d * 100
    actual_percentage >= threshold_percentage ? 1 : 0
  end

  def warn_for_multiple_mentors
    Rails.logger.warn "[Attention] retrieving one of multiple mentors for student: #{id}" if
    ProtocolSubscription.active.where(filling_out_for_id: id).where.not(person_id: id).count > 1
  end

  def not_own_parent
    return if id.blank? || parent_id.blank? || id != parent_id

    errors.add(:parent, 'cannot be parent of yourself')
  end
end
