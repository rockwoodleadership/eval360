require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
#  http://www.wegtam.net/article/ruby-rails-and-activeadmin-assets-heroku
Bundler.require(:default, :assets, Rails.env)


module Eval360
  class Application < Rails::Application

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
