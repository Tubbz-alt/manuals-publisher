source "https://rubygems.org"

gem "rails", "3.2.22.3"

# Alphabetical order please :)
gem "airbrake", "3.1.15"
gem "faraday", "0.9.0"
gem "fetchable", "1.0.0"
gem "foreman", "0.74.0"
gem "gds-sso", "10.1.0"
gem "generic_form_builder", "0.11.0"
gem "govuk_admin_template", "3.0.0"
gem "kaminari", "0.16.1"
gem "logstasher", "0.4.8"
gem "mongoid", "2.5.2"
gem "mongoid_rails_migrations", "1.0.0"
gem "multi_json", "1.10.0"
gem "plek", "1.12.0"
gem "quiet_assets", "1.0.3"
gem "raindrops", ">= 0.13.0" # we need a version > 0.13.0 for ruby 2.2
gem "rack", "~> 1.4.6" # explicitly requiring patched version re: CVE-2015-3225
gem "sidekiq", "3.2.1"
gem "sidekiq-statsd", "0.1.5"
gem "unicorn", "4.8.2"

if ENV["API_DEV"]
  gem "gds-api-adapters", path: "../gds-api-adapters"
else
  gem "gds-api-adapters", "37.4.0"
end

if ENV["CONTENT_MODELS_DEV"]
  gem "govuk_content_models", path: "../govuk_content_models"
else
  gem "govuk_content_models", "28.7.0"
end

if ENV["GOVSPEAK_DEV"]
  gem "govspeak", path: "../govspeak"
else
  gem "govspeak", "3.1.0"
end

group :assets do
  gem "govuk_frontend_toolkit", "0.44.0"
  gem "sass-rails", "3.2.6"
  gem "uglifier", ">= 1.3.0"
end

group :development do
  gem "better_errors"
  gem "binding_of_caller"
end

group :development, :test do
  gem "awesome_print"
  gem "jasmine-rails"
  gem "pry-byebug"
  gem "sinatra"
end

group :test do
  gem "cucumber", "~> 2.2.0"
  gem "cucumber-rails", "~> 1.4.0", require: false
  gem "database_cleaner", "1.2.0"
  gem "factory_girl_rails", "4.8.0"
  gem "govuk-lint"
  gem "govuk-content-schema-test-helpers", "1.4.0"
  gem "launchy"
  gem "poltergeist", "1.5.0"
  gem "phantomjs", ">= 1.9.7.1"
  gem "rspec", "~> 3.2.0"
  gem "rspec-rails", "~> 3.2.0"
  gem "simplecov"
  # we need test-unit for rails 3.2 and ruby 2.2
  gem 'test-unit', require: false
  gem "timecop"
  gem "webmock", "~> 1.17.4"
end
