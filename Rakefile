require 'rubygems/package_task'
require File.expand_path('../lib/version', __FILE__)
spec = Gem::Specification.new do |s|
  s.name        = 'ey_info'
  s.version     = EyInfo::Version
  s.summary     = %Q{Ey Info - Easy way to setup ssh keys for ey cloud servers}
  s.description = %Q{Ey Info - Easy way to setup ssh keys for ey cloud servers and also to dynamically pull server information from your ey servers and just it within capistrano.}
  s.authors     = ["Tung Nguyen"]
  s.email       = [ "tongueroo@gmail.com" ]
  s.files       = `find lib -type f`.split("\n")
  s.homepage    = "http://github.com/tongueroo/ey_info"
  s.executables = %W(ey_info)
  s.add_dependency "engineyard", "1.3.17"
end
Gem::PackageTask.new(spec) do |pkg|
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

task :test => :check_dependencies
task :default => :test

