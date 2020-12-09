# frozen_string_literal: true

FactoryBot.define do
  factory :measurement do
    questionnaire
    protocol
    open_from_offset { (1.day + 13.hours).to_i } # Tuesday 1pm
    open_duration { 2.hours.to_i }
    reward_points { 1 }
    should_invite { true }
    collapse_duplicates { true }
    stop_measurement { false }
    trait :stop_measurement do
      stop_measurement { true }
    end
    trait :periodical do
      period { 1.week.to_i }
    end
    trait :periodical_and_overlapping do
      period { 1.day.to_i }
      open_duration { 36.hours.to_i }
      open_from_offset { 9.hours.to_i }
    end
    trait :relative_to_end_date do
      offset_till_end { (2.days + 11.hours).to_i } # Friday 1pm
    end
    trait :with_redirect_url do
      redirect_url { '/person/edit' }
    end
  end
end
