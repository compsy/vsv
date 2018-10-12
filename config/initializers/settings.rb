# frozen_string_literal: true

require 'ostruct'
Rails.application.configure do
  settings = config_for(:settings)
  settings = JSON.parse(settings.to_json)
  project_name = settings['application_name']

  if project_name.present? && !Rails.env.test?
    project_base = Rails.root.join('config', 'projects', project_name)
    settings_file = Rails.root.join(project_base, 'settings.yml')
    locales_dir = Rails.root.join(project_base, 'locales')

    if File.exist?(settings_file)
      project_specific_settings = config_for(settings_file)
      project_specific_settings = JSON.parse(project_specific_settings.to_json)
      settings.deep_merge!(project_specific_settings)
    end

    config.i18n.load_path += Dir[Rails.root.join(locales_dir, '**', '*.{rb,yml}').to_s] if Dir.exist?(locales_dir)
  end

  # Convert the settings to a nested openstruct, which allows us to do
  # Rails.application.config.settings.nested_something.nested_array
  config.settings = JSON.parse settings.to_json, object_class: OpenStruct
end
