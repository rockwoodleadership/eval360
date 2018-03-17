require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Eval360
  class Application < Rails::Application
    config.load_defaults 5.1

    config.generators do |g|
      g.view_specs false
      g.helper_specs false
      g.controller_specs false
      g.model_specs false
      g.stylesheets false
      g.javascripts false
      g.helper false
      g.test_framework :rspec
      g.factory_bot dir: '/spec/factories/'
    end

    config.serve_static_files = true

    config.active_record.belongs_to_required_by_default = false

    config.x.loi = "YearlongIndividual"
  end
end
