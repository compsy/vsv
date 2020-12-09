# frozen_string_literal: true

class Measurement < ApplicationRecord
  DEFAULT_REMINDER_DELAY = 8.hours
  WEEKDAYS = %w[sunday monday tuesday wednesday thursday friday saturday].freeze
  MIN_PRIORITY = -10_000
  MAX_PRIORITY = 10_000

  belongs_to :questionnaire
  validates :questionnaire_id, presence: true
  belongs_to :protocol # , autosave: true, validate: true
  validate :at_most_one_stop_measurement_per_protocol
  validates :protocol_id, presence: true
  validates :stop_measurement, inclusion: { in: [true, false] }
  validates :should_invite, inclusion: { in: [true, false] }
  # period can be nil, in which case the questionnaire is one-off and not repeated
  validates :period, numericality: { only_integer: true, allow_nil: true, greater_than: 0 }
  # open_duration can be nil, in which case the questionnaire can be filled out until the end of the protocol
  validates :open_duration, numericality: { only_integer: true, allow_nil: true, greater_than_or_equal_to: 0 }
  # either open_from_offset or offset_till_end has to be specified
  validates :open_from_offset, numericality: { only_integer: true, allow_nil: true, greater_than_or_equal_to: 0 }
  # open_from_day is optional, if specified, it means that the open_from_offset (if present) is added to midnight
  # of the specified day. Note that it is allowed (but never needed) to have open_from_offset > 24 hours if an
  # open_from_day is also specified. It just means that if you set open_from_day on a thursday, and open_from_offset
  # to 36 hours, that it will be noon on a friday (which you also could've done with open_from_day friday and
  # open_from_offset 12 hours). If the day of the start_date of the protocol subscription is the same as open_from_day,
  # it will schedule the response for the same day if start_date.beginning_of_day + open_from_offset is
  # equal to or larger than start_date (the start date of the protocol subscription itself). Otherwise, it will be
  # scheduled a week later.
  validates :open_from_day, inclusion: { in: [nil] + WEEKDAYS }
  validates :offset_till_end, numericality: { only_integer: true, allow_nil: true, greater_than_or_equal_to: 0 }
  validates :reward_points, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :priority, numericality: { only_integer: true, allow_nil: true,
                                       greater_than_or_equal_to: MIN_PRIORITY, less_than_or_equal_to: MAX_PRIORITY }

  validates :reminder_delay, numericality: { only_integer: true, allow_nil: true, greater_than_or_equal_to: 0 }
  validates :collapse_duplicates, inclusion: [true, false]

  validate :either_open_from_or_offset_till_end
  validate :no_otr_and_should_invite

  has_many :responses, dependent: :destroy

  def periodical?
    period.present?
  end

  def response_times(start_date, end_date)
    return [1.minute.ago.in_time_zone] if protocol.otr_protocol?

    # A periodical measurement is one which is recorded every now and then
    # following some srt of protocol / procedure. These measurements need more
    # responses.
    return periodical_response_times(start_date, end_date) if periodical?

    # If the offset_till_end is provided, we want the measurement to be open
    # till a certain end date, instead of a start date. This only holds for non
    # periodical questionnaires
    return [open_till(end_date)] if offset_till_end.present?

    [open_from(start_date)]
  end

  private

  def periodical_response_times(start_date, end_date)
    response_times = []
    temp_open_from = open_from(start_date)
    temp_open_till = open_till(end_date)
    while temp_open_from < temp_open_till
      response_times << temp_open_from
      temp_open_from = TimeTools.increase_by_duration(temp_open_from, period)
    end

    response_times
  end

  def at_most_one_stop_measurement_per_protocol
    return unless stop_measurement && protocol_id.present?

    protocol.reload
    stop_measurement_already_available = protocol_has_other_stop_measurement?
    protocol.measurements.reset
    return unless stop_measurement_already_available

    errors.add(:protocol, 'can only have a single stop_measurement')
  end

  def protocol_has_other_stop_measurement?
    protocol.stop_measurement.present? && protocol.stop_measurement != self
  end

  def open_till(end_date)
    if offset_till_end.present?
      TimeTools.increase_by_duration(end_date, -offset_till_end)
    else
      end_date
    end
  end

  # Note that this may produce an open_from time that is after the end_date, but only for nonperiodical measurements.
  # This is done on purpose (we assume that if people create a measurement, they want it to run). And it will not exceed
  # the end date by more than a week.
  def open_from(start_date)
    return open_from_with_offset(start_date) if open_from_day.blank?

    new_start_date = start_date.beginning_of_day
    while WEEKDAYS[new_start_date.wday] != open_from_day || open_from_with_offset(new_start_date) < start_date
      # We go to the next day, but if it's daylight savings time switches, the next day can be more or less
      # than 24 hours away, so to be sure we first go to noon the next day, and then back to the beginning
      # of that day.
      new_start_date = TimeTools.increase_by_duration(new_start_date, 36.hours).beginning_of_day
    end
    open_from_with_offset(new_start_date)
  end

  def open_from_with_offset(start_date)
    if open_from_offset.present?
      TimeTools.increase_by_duration(start_date, open_from_offset)
    else
      start_date
    end
  end

  def either_open_from_or_offset_till_end
    if periodical?
      open_from_offset_cannot_be_blank
    else
      offsets_cannot_both_be_blank
      offsets_cannot_both_be_present
    end
  end

  def no_otr_and_should_invite
    errors.add(:should_invite, 'cannot be set for an otr protocol') if should_invite? && protocol&.otr_protocol?
  end

  def open_from_offset_cannot_be_blank
    return if open_from_offset.present?

    errors.add(:open_from_offset, 'cannot be blank')
  end

  def offsets_cannot_both_be_blank
    return unless open_from_offset.blank? && offset_till_end.blank?

    errors.add(:open_from_offset, 'cannot be blank if offset_till_end is blank')
    errors.add(:offset_till_end, 'cannot be blank if open_from_offset is blank')
  end

  def offsets_cannot_both_be_present
    return unless open_from_offset.present? && offset_till_end.present?

    errors.add(:open_from_offset, 'cannot be present if offset_till_end is present')
    errors.add(:offset_till_end, 'cannot be present if open_from_offset is present')
  end
end
