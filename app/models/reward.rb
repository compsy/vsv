# frozen_string_literal: true

class Reward < ApplicationRecord
  validates :threshold, numericality: { only_integer: true, greater_than: 0 }
  validates :reward_points, numericality: { only_integer: true, greater_than: 0 }
  validates :protocol, presence: true
  validates_uniqueness_of :threshold, scope: :protocol_id
  belongs_to :protocol

  def self.total_euros
    students = Person.all.reject(&:mentor?)
    total_reward_points = students.sum(&:reward_points)
    total_reward_points / 100.0
  end

  def self.max_still_earnable_euros
    students = Person.all.reject(&:mentor?)
    max_still_earnable_reward_points = students.sum(&:max_still_earnable_reward_points)
    max_still_earnable_reward_points / 100.0
  end
end
