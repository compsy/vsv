# frozen_string_literal: true

class ProtocolSubscription < ApplicationRecord
  include ActiveModel::Validations
  ACTIVE_STATE = 'active'
  CANCELED_STATE = 'canceled'
  COMPLETED_STATE = 'completed'
  belongs_to :person
  belongs_to :filling_out_for, class_name: 'Person', inverse_of: false
  validates :person_id, presence: true # The person who receives the SMS (Mentor)
  validates :filling_out_for_id, presence: true # Student ID
  belongs_to :protocol
  validates :protocol_id, presence: true
  validates :state, inclusion: { in: [ACTIVE_STATE, CANCELED_STATE, COMPLETED_STATE] }
  validates :start_date, presence: true
  validates :end_date, presence: true

  # Note: this ordering is important for a number of reasons. E.g.:
  # - Response.last? uses it to determine if this is the last in the set.
  has_many :responses, -> { order open_from: :asc }, dependent: :destroy, inverse_of: :protocol_subscription
  after_initialize :initialize_filling_out_for
  after_initialize :initialize_end_date
  after_create :schedule_responses
  has_many :protocol_transfers, dependent: :destroy

  # Commented this to allow to start multiple mentor'ed diary studies for the SDV project.
  # validates :filling_out_for_id,
  #           uniqueness: { scope: %i[person_id state],
  #                         conditions: -> { where(state: ACTIVE_STATE) },
  #                         if: ->(sub) { sub.person_id != sub.filling_out_for_id } }
  scope :active, (-> { where(state: ACTIVE_STATE) })

  def transfer!(transfer_to)
    raise('The person you transfer to should not be the same as the original person!') if transfer_to == person

    protocol_transfers << ProtocolTransfer.new(from: person, to: transfer_to, protocol_subscription_id: id)
    self.filling_out_for = transfer_to if for_myself?
    self.person = transfer_to
    save!
  end

  def stop_response
    # We can be sure there is always at most one stop response as this is forced / validated in the
    # protocol class.
    responses.joins(:measurement).find_by(measurements: { stop_measurement: true })
  end

  def active?
    state == ACTIVE_STATE
  end

  def canceled?
    state == CANCELED_STATE
  end

  def cancel!
    update!(state: CANCELED_STATE, end_date: Time.zone.now)
    responses.future.destroy_all
  end

  def ended?
    Time.zone.now > end_date
  end

  def for_myself?
    person == filling_out_for
  end

  def mentor?
    !for_myself?
  end

  def earned_euros(check_future = false)
    protocol.calculate_reward(completion, check_future) / 100.0
  end

  def protocol_completion
    on_streak = 0
    responses.map do |response|
      on_streak, current_streak = retrieve_periodical_streak(on_streak, response)

      create_protocol_completion_entry(response.completed?,
                                       response.measurement.periodical?,
                                       response.measurement.reward_points,
                                       response.still_possible?,
                                       current_streak,
                                       response.future_or_current?)
    end
  end

  def retrieve_periodical_streak(on_streak, response)
    if response.measurement.periodical?
      on_streak = determine_streak(on_streak, response.completed?, response.still_possible?)

      # Return the on_streak twice, so we update the current_streak
      return [on_streak, on_streak]
    end
    [on_streak, -1]
  end

  def needs_informed_consent?
    !(protocol.informed_consent_questionnaire.blank? ||
      informed_consent_given_at.present?)
  end

  def completion
    # cached version
    @completion ||= protocol_completion
  end

  def max_still_earnable_reward_points
    from = latest_streak_value_index + 1
    to = from + responses.future.length
    sliced_completion = completion.slice((from...to))
    protocol.calculate_reward(sliced_completion, true)
  end

  def latest_streak_value_index
    completion_index = completion.find_index { |entry| entry[:future] }
    return -1 if completion_index.nil?

    completion_index - 1
  end

  private

  def determine_streak(streak, current_response_completed, current_response_in_future)
    return streak + 1 if current_response_completed || current_response_in_future

    0
  end

  def create_protocol_completion_entry(is_completed, is_periodical,
                                       reward_points, is_in_future, streak, future_or_current)
    result = {}
    result[:completed] = is_completed
    result[:periodical] = is_periodical
    result[:reward_points] = reward_points
    result[:future] = is_in_future
    result[:streak] = streak
    result[:future_or_current] = future_or_current

    result
  end

  def initialize_filling_out_for
    # Note that this means that if the person you're filling out the protocol subscription for
    # is destroyed, then the filling_out_for automatically gets reset back to yourself.
    self.filling_out_for ||= person
  end

  def initialize_end_date
    self.end_date ||= TimeTools.increase_by_duration(start_date, protocol.duration) if
      start_date.present? && protocol.present?
  end

  def schedule_responses
    RescheduleResponses.run!(protocol_subscription: self, future: 10.minutes.ago)
  end
end
