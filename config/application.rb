require File.expand_path('../boot', __FILE__)

require 'rails/all'
require "base64"
require "databasedotcom-oauth2"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
#  http://www.wegtam.net/article/ruby-rails-and-activeadmin-assets-heroku
Bundler.require(:default, :assets, Rails.env)


VARS=%w(TOKEN_ENCRYPTION_KEY CONSUMER_KEY CONSUMER_SECRET)
VARS.keep_if{|var| ENV[var].nil? || ENV[var].empty?}
fail "Environment Variables required: #{VARS.join(',')}" if(!VARS.empty?)



module Eval360
  class Application < Rails::Application
    config.middleware.use Databasedotcom::OAuth2::WebServerFlow,
      token_encryption_key: Base64.strict_decode64(ENV['TOKEN_ENCRYPTION_KEY']),
      endpoints: {"login.salesforce.com" => {"key" => ENV['CONSUMER_KEY'], 
                                             "secret" => ENV['CONSUMER_SECRET']}}

    config.generators do |g|
      g.view_specs false
      g.helper_specs false
      g.controller_specs false
      g.model_specs false
      g.stylesheets false
      g.javascripts false
      g.helper false
      g.test_framework :rspec
      g.factory_girl dir: '/spec/factories/'
    end

    config.serve_static_assets = true

  end
end
