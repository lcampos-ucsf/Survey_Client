# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{faker}
  s.version = "0.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Benjamin Curtis}]
  s.date = %q{2008-04-03}
  s.description = %q{A port of Perl's Data::Faker - Generates fake names, phone numbers, etc.}
  s.email = %q{benjamin.curtis@gmail.com}
  s.extra_rdoc_files = [%q{History.txt}, %q{License.txt}, %q{Manifest.txt}, %q{README.txt}]
  s.files = [%q{History.txt}, %q{License.txt}, %q{Manifest.txt}, %q{README.txt}]
  s.homepage = %q{http://faker.rubyforge.org}
  s.rdoc_options = [%q{--main}, %q{README.txt}]
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{faker}
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{A port of Perl's Data::Faker - Generates fake names, phone numbers, etc.}

  if s.respond_to? :specification_version then
    s.specification_version = 2

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
