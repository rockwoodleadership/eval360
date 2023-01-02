source 'https://rubygems.org'

ruby '2.7.2'
gem 'rails', '5.2.0'
gem 'pg', '~>0.21.0'
gem 'jquery-rails'
gem 'coffee-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'slim-rails'
gem 'turbolinks'
gem 'devise'
gem 'activeadmin', '~>2.9.0'
gem 'active_record-acts_as'
gem 'mandrill-api'
gem 'formtastic', '~> 3.1.5'
gem 'formtastic-bootstrap'
gem "cocoon"
gem 'bugsnag'
gem 'prawn'
gem 'delayed_job_active_record', '4.1.4'
gem 'rubyzip'
gem 'restforce'
gem 'newrelic_rpm'
gem 'render_async'
gem 'bundle-audit'
gem "rails-html-sanitizer", ">= 1.0.4"

group :production do
  gem 'unicorn'
  gem 'rails_serve_static_assets'
end

group :development do
  gem 'rack-mini-profiler'
  gem 'thin'
  gem 'guard-rspec', require: false
  gem "spring"
  gem "spring-commands-rspec"
end

group :development, :test do
  gem "bullet"
  gem 'dotenv-rails', '~>2.2.2'
  gem 'pry'
  gem 'rspec-rails', '~> 3.7'
  gem "factory_bot_rails", require: false
end

group :test do
  gem 'shoulda-matchers', require: false
  gem 'shoulda-callback-matchers', '~> 1.0'
  gem 'rake'
  gem 'dotenv-deployment'
  gem 'simplecov', require: false, group: :test
  gem 'webmock'
  gem 'database_cleaner'
  gem 'rails-controller-testing'
end


