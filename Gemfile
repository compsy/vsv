# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify ruby version for heroku
ruby '2.6.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3'

# Use Postgres as the database for Active Record
gem 'pg', '= 1.1.4'

# Driver for Redis datastore
gem 'redis'

# Use Puma as the app server
gem 'puma'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use HAML for templates
gem 'haml-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'

# Use React for the UI
gem 'react-rails'
gem 'react-source'

# Use highcharts
gem 'highcharts-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

# Driver for the mongo database
gem 'mongoid'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
gem 'redis-mutex'

# Use ActiveModel has_secure_password
gem 'bcrypt'

# Enable cross origin requests
gem 'rack-cors'

gem 'pry-rails'

gem 'dotenv-rails'

gem 'coveralls_reborn', require: false

# Delayed job for delayed calculation
gem 'delayed_job_active_record'

# Used to scroll to top
gem 'animate-rails', github: 'camelmasa/animate-rails'

# Messagebird SMS
gem 'messagebird-rest', require: 'messagebird'

# Email via mailgun
gem 'mailgun-ruby'

gem 'active_interaction'
gem 'active_model_serializers'

# Gem for JWT / Authentication
gem 'jwt'

# current master, using this because the version on rubygems hasn't been updated
gem 'knock', github: 'nsarno/knock', ref: '37e403a7c6d44f585b56a086245e41566a8d6fe1'

# Gem for authorization
# Using the 3.0 version because of this: https://github.com/CanCanCommunity/cancancan/pull/474
gem 'cancancan', github: 'CanCanCommunity/cancancan', ref: '6e782102f5dfef4bd3cc3feadc49802ea942c234'

# Gem for calling deadmanssnitch
gem 'snitcher'

# Gem for checking iban bank accounts
gem 'iban-tools'

# Swagger
gem 'rswag-api'
gem 'rswag-ui'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]

  # Swagger
  gem 'rswag-specs'

  # Needed for Circleci to pretty format the output
  gem 'guard-rspec'
  gem 'rspec_junit_formatter'
  gem 'rspec-rails'
end

group :test do
  # Code quality monitoring
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'

  # Allows jumping back and forth in time
  gem 'timecop'

  # Code coverage reporter
  gem 'simplecov'

  # Used for gem mocking
  gem 'factory_bot_rails'

  # Test which template was rendered
  gem 'rails-controller-testing'

  # Cleans the database after specs
  gem 'database_cleaner'
  gem 'database_cleaner-active_record'
  gem 'database_cleaner-mongoid'

  # Integration testing
  gem 'capybara'
  gem 'capybara-screenshot'

  # selenium for js testing
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

group :production, :staging do
  # See https://github.com/rails/execjs#readme for more supported runtimes
  gem 'mini_racer', platforms: :ruby

  # Required by Delayed Job
  gem 'daemons'
end

gem 'addressable'

gem 'workless', git: 'https://github.com/compsy/workless.git', branch: 'fixes'

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen'
  gem 'web-console'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen'
end

# Silence noisy requests like /status
gem 'silencer'

# JS / CSS Frameworks
gem 'materialize-sass'
gem 'modernizr-rails'

gem 'webpacker', '>=6.0.0.pre.2'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data'

gem 'i18n-js' # We still need this gem because it generates translations.js for us.
gem 'rails-i18n'

gem 'lograge'
gem 'remote_syslog_logger'

gem 'appsignal'

# push subscriptions
gem 'httparty'
gem 'warden-jwt_auth'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false
