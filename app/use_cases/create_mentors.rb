# frozen_string_literal: true

require 'csv' # Not a gem: in ruby stdlib

class CreateMentors < ActiveInteraction::Base
  array :mentors

  # Creates mentors from the given array created with EchoPeople
  #
  # Params:
  # - mentors: the array containing the mentor details including the students they will supervise
  def execute
    plain_text_parser = PlainTextParser.new
    parsed_mentors = parse_mentors(mentors, plain_text_parser)
    number_of_created_mentors = create_mentors(parsed_mentors)
    puts "Created #{number_of_created_mentors}/#{parsed_mentors.size} mentors." unless Rails.env.test?
  end

  private

  def parse_mentors(mentors, plain_text_parser)
    mentors.map do |mentor|
      {
        first_name: mentor[:first_name],
        last_name: mentor[:last_name],
        mobile_phone: plain_text_parser.parse_mobile_phone(mentor[:mobile_phone]),
        protocol_id: plain_text_parser.parse_protocol_name(mentor[:protocol_name]),
        start_date: plain_text_parser.parse_start_date(mentor[:start_date]),
        filling_out_for_id: plain_text_parser.parse_filling_out_for(mentor[:filling_out_for]),
        filling_out_for_protocol_id: plain_text_parser.parse_protocol_name(mentor[:filling_out_for_protocol]),
        organization_id: plain_text_parser.parse_organization_name(mentor[:organization_name])
      }
    end
  end

  def create_mentors(mentors)
    number_of_mentors = 0
    mentors.each do |mentor|
      mentor_obj = Person.find_by_mobile_phone(mentor[:mobile_phone])
      mentor_obj = initialize_mentor(mentor) if mentor_obj.nil?

      ProtocolSubscription.create!(person: mentor_obj,
                                   filling_out_for_id: mentor[:filling_out_for_id],
                                   protocol_id: mentor[:filling_out_for_protocol_id],
                                   state: ProtocolSubscription::ACTIVE_STATE,
                                   start_date: mentor[:start_date])
      number_of_mentors += 1
    end
    number_of_mentors
  end

  def initialize_mentor(mentor_hash)
    mentor_obj = Mentor.create!(first_name: mentor_hash[:first_name],
                                last_name: mentor_hash[:last_name],
                                mobile_phone: mentor_hash[:mobile_phone],
                                organization_id: mentor_hash[:organization_id])
    ProtocolSubscription.create!(person: mentor_obj,
                                 protocol_id: mentor_hash[:protocol_id],
                                 state: ProtocolSubscription::ACTIVE_STATE,
                                 start_date: mentor_hash[:start_date])
    mentor_obj
  end
end
