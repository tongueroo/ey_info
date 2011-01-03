# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ey_info}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tung Nguyen"]
  s.date = %q{2011-01-03}
  s.default_executable = %q{ey_info}
  s.description = %q{Ey Info - Easy way to setup ssh keys for ey cloud servers and also to dynamically pull server information from your ey servers and just it within capistrano.}
  s.email = ["tongueroo@gmail.com"]
  s.executables = ["ey_info"]
  s.extra_rdoc_files = [
    "README.markdown",
    "TODO"
  ]
  s.files = [
    "README.markdown",
    "Rakefile",
    "TODO",
    "bin/ey_info",
    "lib/ey_info.rb",
    "lib/templates/default_ssh_config.erb",
    "lib/text_injector.rb",
    "test/ey_info_test.rb",
    "test/test_helper.rb"
  ]
  s.homepage = %q{http://github.com/tongueroo/ey_info}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Ey Info - Easy way to setup ssh keys for ey cloud servers}
  s.test_files = [
    "test/ey_info_test.rb",
    "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<engineyard>, [">= 1.3.11"])
    else
      s.add_dependency(%q<engineyard>, [">= 1.3.11"])
    end
  else
    s.add_dependency(%q<engineyard>, [">= 1.3.11"])
  end
end

