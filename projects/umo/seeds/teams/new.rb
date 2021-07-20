# frozen_string_literal: true

# team_name = 'Demo-team'
#
# organization_name = 'Demo-organization'
# organization = Organization.find_by(name: organization_name)
#
# puts "Running seeds for #{team_name}"
# team = Team.find_by(name: team_name)
# team ||= Team.create!(name: team_name, organization: organization)
# team.update!(organization: organization)
#
# title = 'Demo-solo'
# entry = team.roles.where(group: Person::SOLO, title: title).first
# entry ||= team.roles.create!(group: Person::SOLO, title: title)
#
# title = 'Demo-student'
# entry = team.roles.where(group: Person::STUDENT, title: title).first
# entry ||= team.roles.create!(group: Person::STUDENT, title: title)
#
# title = 'Demo-mentor'
# entry = team.roles.where(group: Person::MENTOR, title: title).first
# entry ||= team.roles.create!(group: Person::MENTOR, title: title)
