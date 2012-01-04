# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "apotomo"
  s.version = "1.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nick Sutterer"]
  s.date = "2011-10-13"
  s.description = "Web component framework for Rails providing widgets that trigger events and know when and how to update themselves with AJAX."
  s.email = ["apotonick@gmail.com"]
  s.homepage = "http://github.com/apotonick/apotomo"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.12"
  s.summary = "Web components for Rails."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<cells>, [">= 3.6.7"])
      s.add_runtime_dependency(%q<onfire>, ["~> 0.2.0"])
      s.add_runtime_dependency(%q<hooks>, ["~> 0.2.0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<slim>, [">= 0"])
      s.add_development_dependency(%q<haml>, [">= 0"])
      s.add_development_dependency(%q<tzinfo>, [">= 0"])
    else
      s.add_dependency(%q<cells>, [">= 3.6.7"])
      s.add_dependency(%q<onfire>, ["~> 0.2.0"])
      s.add_dependency(%q<hooks>, ["~> 0.2.0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<slim>, [">= 0"])
      s.add_dependency(%q<haml>, [">= 0"])
      s.add_dependency(%q<tzinfo>, [">= 0"])
    end
  else
    s.add_dependency(%q<cells>, [">= 3.6.7"])
    s.add_dependency(%q<onfire>, ["~> 0.2.0"])
    s.add_dependency(%q<hooks>, ["~> 0.2.0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<slim>, [">= 0"])
    s.add_dependency(%q<haml>, [">= 0"])
    s.add_dependency(%q<tzinfo>, [">= 0"])
  end
end
