# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{cells}
  s.version = "3.6.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Nick Sutterer}]
  s.date = %q{2011-09-27}
  s.description = %q{Cells are view components for Rails. They are lightweight controllers, can be rendered in views and thus provide an elegant and fast way for encapsulation and component-orientation.}
  s.email = [%q{apotonick@gmail.com}]
  s.homepage = %q{http://cells.rubyforge.org}
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{View Components for Rails.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<actionpack>, ["~> 3.0"])
      s.add_runtime_dependency(%q<railties>, ["~> 3.0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<haml>, [">= 0"])
      s.add_development_dependency(%q<slim>, [">= 0"])
      s.add_development_dependency(%q<tzinfo>, [">= 0"])
    else
      s.add_dependency(%q<actionpack>, ["~> 3.0"])
      s.add_dependency(%q<railties>, ["~> 3.0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<haml>, [">= 0"])
      s.add_dependency(%q<slim>, [">= 0"])
      s.add_dependency(%q<tzinfo>, [">= 0"])
    end
  else
    s.add_dependency(%q<actionpack>, ["~> 3.0"])
    s.add_dependency(%q<railties>, ["~> 3.0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<haml>, [">= 0"])
    s.add_dependency(%q<slim>, [">= 0"])
    s.add_dependency(%q<tzinfo>, [">= 0"])
  end
end
