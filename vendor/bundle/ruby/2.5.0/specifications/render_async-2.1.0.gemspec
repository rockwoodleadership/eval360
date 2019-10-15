# -*- encoding: utf-8 -*-
# stub: render_async 2.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "render_async".freeze
  s.version = "2.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Kasper Grubbe".freeze, "nikolalsvk".freeze]
  s.bindir = "exe".freeze
  s.date = "2019-05-06"
  s.description = "Load parts of your page through simple JavaScript and Rails pipeline".freeze
  s.email = ["nikolaseap@gmail.com".freeze]
  s.homepage = "https://github.com/renderedtext/render_async".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.9".freeze
  s.summary = "Render parts of the page asynchronously with AJAX".freeze

  s.installed_by_version = "2.7.9" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>.freeze, ["~> 10.0"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.2"])
      s.add_development_dependency(%q<codeclimate-test-reporter>.freeze, ["~> 1.0.8"])
    else
      s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.2"])
      s.add_dependency(%q<codeclimate-test-reporter>.freeze, ["~> 1.0.8"])
    end
  else
    s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.2"])
    s.add_dependency(%q<codeclimate-test-reporter>.freeze, ["~> 1.0.8"])
  end
end
