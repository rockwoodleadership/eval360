# -*- encoding: utf-8 -*-
# stub: formtastic-bootstrap 3.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "formtastic-bootstrap".freeze
  s.version = "3.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Matthew Bellantoni".freeze, "Aaron Stone".freeze]
  s.date = "2015-07-19"
  s.description = "Formtastic form builder to generate Twitter Bootstrap-friendly markup.".freeze
  s.email = ["mjbellantoni@yahoo.com".freeze, "aaron@serendipity.cx".freeze]
  s.extra_rdoc_files = ["LICENSE.txt".freeze, "README.md".freeze]
  s.files = ["LICENSE.txt".freeze, "README.md".freeze]
  s.homepage = "http://github.com/mjbellantoni/formtastic-bootstrap".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.9".freeze
  s.summary = "Formtastic form builder to generate Twitter Bootstrap-friendly markup.".freeze

  s.installed_by_version = "2.7.9" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<formtastic>.freeze, [">= 3.0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<tzinfo>.freeze, [">= 0"])
      s.add_development_dependency(%q<bundler>.freeze, [">= 0"])
      s.add_development_dependency(%q<nokogiri>.freeze, ["< 1.6.0"])
      s.add_development_dependency(%q<rspec_tag_matchers>.freeze, ["~> 1.0"])
      s.add_development_dependency(%q<ammeter>.freeze, ["~> 0.2"])
      s.add_development_dependency(%q<actionpack>.freeze, ["~> 3.2"])
    else
      s.add_dependency(%q<formtastic>.freeze, [">= 3.0"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<tzinfo>.freeze, [">= 0"])
      s.add_dependency(%q<bundler>.freeze, [">= 0"])
      s.add_dependency(%q<nokogiri>.freeze, ["< 1.6.0"])
      s.add_dependency(%q<rspec_tag_matchers>.freeze, ["~> 1.0"])
      s.add_dependency(%q<ammeter>.freeze, ["~> 0.2"])
      s.add_dependency(%q<actionpack>.freeze, ["~> 3.2"])
    end
  else
    s.add_dependency(%q<formtastic>.freeze, [">= 3.0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<tzinfo>.freeze, [">= 0"])
    s.add_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_dependency(%q<nokogiri>.freeze, ["< 1.6.0"])
    s.add_dependency(%q<rspec_tag_matchers>.freeze, ["~> 1.0"])
    s.add_dependency(%q<ammeter>.freeze, ["~> 0.2"])
    s.add_dependency(%q<actionpack>.freeze, ["~> 3.2"])
  end
end
