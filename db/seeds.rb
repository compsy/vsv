# frozen_string_literal: true

# Running rake db:reset will leave seeds with a terminated connection.
ActiveRecord::Base.connection.reconnect! if Rails.env.development?

# Require personal question seeds separately because they
# need to already exist when the protocol seeds are loaded, and the
# order is different on production servers.
require File.join(File.dirname(__FILE__),'seeds','questionnaire_seeds.rb')
# Load seeds from the seeds directory.
Dir[File.join(File.dirname(__FILE__),'seeds','*.rb')].each do |file|
  require file
end

# WARNING: seeds below are not idempotent: use dbsetup after changing something
# WARNING: please use create! instead of create everywhere in seeds
if Rails.env.development?
  protocol = Protocol.find_by_name('pilot - mentoren 1x per week')
  person = Mentor.first
  students = Student.all[0..-2]

  puts 'mentor urls:'
  students.each do |student|
    prot_sub = ProtocolSubscription.create!(
      protocol: protocol,
      person: person,
      filling_out_for: student,
      state: ProtocolSubscription::ACTIVE_STATE,
      start_date: Time.zone.now.beginning_of_week
    )
    responseobj = prot_sub.responses.first
    responseobj.update_attributes!(
      open_from: 1.minute.ago,
      invited_state: Response::SENT_STATE)
    responseobj.initialize_invitation_token!
    puts "#{Rails.application.routes.url_helpers.root_url}?q=#{responseobj.invitation_token.token}"
  end

  puts 'student url:'
  Student.first.protocol_subscriptions.create(
    protocol: Protocol.find_by_name('pilot - studenten 1x per week'),
    state: ProtocolSubscription::ACTIVE_STATE,
    start_date: Time.zone.now.beginning_of_week
  )
  responseobj = Student.first.protocol_subscriptions.first.responses.first
  responseobj.update_attributes!(
    open_from: 1.minute.ago,
    invited_state: Response::SENT_STATE)
  responseobj.initialize_invitation_token!
  puts "#{Rails.application.routes.url_helpers.root_url}?q=#{responseobj.invitation_token.token}"
end

puts 'Seeds loaded!'
