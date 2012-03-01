# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "rake-compiler"
  s.version = "0.8.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.5") if s.respond_to? :required_rubygems_version=
  s.authors = ["Luis Lavena"]
  s.date = "2012-01-08"
  s.description = "Provide a standard and simplified way to build and package\nRuby extensions (C, Java) using Rake as glue."
  s.email = "luislavena@gmail.com"
  s.executables = ["rake-compiler"]
  s.extra_rdoc_files = ["README.rdoc", "LICENSE.txt", "History.txt"]
  s.files = ["bin/rake-compiler", "README.rdoc", "LICENSE.txt", "History.txt"]
  s.homepage = "http://github.com/luislavena/rake-compiler"
  s.licenses = ["MIT"]
  s.rdoc_options = ["--main", "README.rdoc", "--title", "rake-compiler -- Documentation"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.6")
  s.rubyforge_project = "rake-compiler"
  s.rubygems_version = "1.8.16"
  s.summary = "Rake-based Ruby Extension (C, Java) task generator."

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
