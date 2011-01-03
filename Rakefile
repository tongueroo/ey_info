require File.expand_path('../lib/ey_info', __FILE__)
begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.version         = EyInfo::Version
    gem.name            = "ey_info"
    gem.executables     = %W(ey_info)
    gem.summary         = %Q{Ey Info - Easy way to setup ssh keys for ey cloud servers}
    gem.description     = %Q{Ey Info - Easy way to setup ssh keys for ey cloud servers and also to dynamically pull server information from your ey servers and just it within capistrano.}
    gem.homepage        = "http://github.com/tongueroo/ey_info"
    gem.email           = [ "tongueroo@gmail.com" ]
    gem.authors         = [ "Tung Nguyen" ]
    gem.add_dependency  "engineyard",          ">=1.3.11"
    # gem.add_dependency  "net-sftp",         ">=2.0.0"
    # gem.add_development_dependency "mocha", ">= 0"
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

task :test => :check_dependencies
task :default => :test

