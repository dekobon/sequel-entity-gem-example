# Encoding: utf-8

ENV['ENV'] ||= 'test'

if ENV['production']
  abort('Running tests in the production environment is not allowed, Stupid.')
end

puts "Running with proxy: #{ENV['http_proxy']}" if ENV.key? 'http_proxy'

gem "minitest"
require 'minitest/autorun'
require 'minitest/reporters'

##
# Module encompassing all shared testing components.
module TestCommon
  class << self
    attr_accessor :reporter
  end
end

if ENV['RUBYMINE_TESTUNIT_REPORTER']
  TestCommon.reporter = MiniTest::Reporters::RubyMineReporter.new
else
  # Awesome colorful output
  require 'minitest/pride'
  TestCommon.reporter = MiniTest::Reporters::SpecReporter.new
end

MiniTest::Reporters.use_runner!(TestCommon.reporter, ENV)

require File.expand_path('../../lib/application.rb', __FILE__)

# Setup models a single time
Database.db_setup(single_threaded: true, use_models: true).disconnect
