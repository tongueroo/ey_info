#!/usr/bin/env ruby

ENV['RAILS_ENV'] = 'test'

require 'rubygems'
require 'test/unit'
require 'mocha'
require 'pp'
require File.expand_path("../../lib/ey_info", __FILE__)

module TestExtensions
end

class Test::Unit::TestCase
  include TestExtensions
end
