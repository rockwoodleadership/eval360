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
      g.factory_bot dir: '/spec/factories/'
    end

    config.serve_static_files = true

    initializer 'setup_asset_pipeline', :group => :all  do |app|
      # We don't want the default of everything that isn't js or css, because it pulls too many things in
      app.config.assets.precompile.shift

      # Explicitly register the extensions we are interested in compiling
      app.config.assets.precompile.push(Proc.new do |path|
        File.extname(path).in? [
          '.html', '.erb', '.haml',                 # Templates
          '.png',  '.gif', '.jpg', '.jpeg',         # Images
          '.eot',  '.otf', '.svc', '.woff', '.ttf', # Fonts
        ]
      end)
    end

    config.x.loi = "YearlongIndividual"

  end
end
