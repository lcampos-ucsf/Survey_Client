# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rake-compiler}
  s.version = "0.8.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.5") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Luis Lavena}]
  s.date = %q{2012-01-08}
  s.description = %q{Provide a standard and simplified way to build and package
Ruby extensions (C, Java) using Rake as glue.}
  s.email = %q{luislavena@gmail.com}
  s.executables = [%q{rake-compiler}]
  s.extra_rdoc_files = [%q{README.rdoc}, %q{LICENSE.txt}, %q{History.txt}]
  s.files = [%q{bin/rake-compiler}, %q{README.rdoc}, %q{LICENSE.txt}, %q{History.txt}]
  s.homepage = %q{http://github.com/luislavena/rake-compiler}
  s.licenses = [%q{MIT}]
  s.rdoc_options = [%q{--main}, %q{README.rdoc}, %q{--title}, %q{rake-compiler -- Documentation}]
  s.require_paths = [%q{lib}]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.6")
  s.rubyforge_project = %q{rake-compiler}
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{Rake-based Ruby Extension (C, Java) task generator.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_development_dependency(%q<cucumber>, ["~> 1.1.4"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_dependency(%q<cucumber>, ["~> 1.1.4"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.8.0"])
    s.add_dependency(%q<cucumber>, ["~> 1.1.4"])
  end
end
