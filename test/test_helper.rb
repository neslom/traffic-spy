ENV["RACK_ENV"] ||= "test"

require 'bundler'
Bundler.require

require File.expand_path("../../config/environment", __FILE__)
require 'minitest/autorun'
require 'minitest/pride'
require 'capybara'

Capybara.app = TrafficSpy::Server

require 'database_cleaner'
DatabaseCleaner.strategy = :truncation
