source 'https://rubygems.org'

gem 'rails', '4.1.4'
gem 'pg'
gem 'sass-rails', '5.0.0.beta1'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0',          group: :doc
gem 'slim-rails'
gem 'databasedotcom-oauth2'
gem 'turbolinks'
gem 'devise'
gem 'activeadmin', github: 'activeadmin'
gem 'active_record-acts_as'
gem 'thin', group: :development

group :production do
  gem 'unicorn'
  gem 'rails_serve_static_assets'
end

group :development, :test do
  gem 'dotenv-rails'
  gem 'pry'
end

group :test do
  gem 'rspec-rails', '~> 3.1.0'
  gem 'rspec-activemodel-mocks'
  gem 'shoulda-matchers', require: false
  gem 'shoulda-callback-matchers', '~> 1.0'
  gem 'rake'
  gem 'dotenv-deployment'
  gem "codeclimate-test-reporter", require: nil
end


