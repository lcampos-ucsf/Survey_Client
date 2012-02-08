# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{onfire}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Nick Sutterer}]
  s.date = %q{2011-03-11}
  s.description = %q{Have bubbling events and observers in all your Ruby objects.}
  s.email = [%q{apotonick@gmail.com}]
  s.homepage = %q{http://github.com/apotonick/onfire}
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{Have bubbling events and observers in all your Ruby objects.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
