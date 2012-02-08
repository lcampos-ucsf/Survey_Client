# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{hooks}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Nick Sutterer}]
  s.date = %q{2011-10-05}
  s.description = %q{Declaratively define hooks, add callbacks and run them with the options you like.}
  s.email = [%q{apotonick@gmail.com}]
  s.homepage = %q{http://nicksda.apotomo.de/tag/hooks}
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{Generic hooks with callbacks for Ruby.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
