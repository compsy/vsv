# frozen_string_literal: true

# pr_name = 'demo-solo-protocol'
# demo_solo_protocol = Protocol.find_by(name: pr_name)
# demo_solo_protocol ||= Protocol.new(name: pr_name)
# demo_solo_protocol.duration = 1.day
# demo_solo_protocol.informed_consent_questionnaire = Questionnaire.find_by(name: 'demo-ic')
# raise 'informed consent questionnaire not found' unless demo_solo_protocol.informed_consent_questionnaire
#
# demo_solo_protocol.save!
#
# # Add solo
# questionnaire_name = 'demo'
# questionnaire_id = Questionnaire.find_by(name: questionnaire_name)&.id
# raise "Cannot find questionnaire: #{questionnaire_name}" unless questionnaire_id
#
# demo_measurement = demo_solo_protocol.measurements.find_by(questionnaire_id: questionnaire_id)
# demo_measurement ||= demo_solo_protocol.measurements.build(questionnaire_id: questionnaire_id)
# demo_measurement.open_from_offset = 0 # open right away
# demo_measurement.period = nil # one-off and not repeated
# demo_measurement.open_duration = nil # always open
# demo_measurement.reward_points = 0
# demo_measurement.stop_measurement = true # unsubscribe immediately
# demo_measurement.should_invite = false # don't send invitations
# demo_measurement.redirect_url = '/person/edit' # after filling out questionnaire, go to person edit page.
# demo_measurement.save!
