pr_name = File.basename(__FILE__)[0...-3]
boek_protocol = Protocol.find_by_name(pr_name)
boek_protocol ||= Protocol.new(name: pr_name)
boek_protocol.duration = 3.years

boek_protocol.save!
Dir[Rails.root.join('projects',
                    'ikia',
                    'seeds',
                    'questionnaires',
                    'jongeren',
                    '**',
                    '*.rb')].map { |x| File.basename(x, '.rb') }.each do |questionnaire_key|
  next if %w[jongeren_krachten_16_tot_18 jongeren_start_16_tot_18].include?(questionnaire_key)

  questionnaire = Questionnaire.find_by(key: questionnaire_key)
  next unless questionnaire

  # Create the protocol for the questionnaire

  boek_id = questionnaire.id
  boek_measurement = boek_protocol.measurements.find_by_questionnaire_id(boek_id)
  boek_measurement ||= boek_protocol.measurements.build(questionnaire_id: boek_id)
  boek_measurement.open_from_offset = 0 # open right away
  boek_measurement.period = nil # one-off and not repeated
  boek_measurement.open_duration = nil # open for the entire duration of the protocol
  boek_measurement.reward_points = 0
  boek_measurement.stop_measurement = false
  boek_measurement.should_invite = false # don't send invitations
  boek_measurement.redirect_url = '/klaar' # is overridden by callback_url passed
  boek_measurement.save!
end