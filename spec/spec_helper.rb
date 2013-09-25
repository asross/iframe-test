ENV['RACK_ENV'] = 'test'

require_relative '../app.rb'
require 'rspec/autorun'
require 'capybara/rspec'
require 'pry'
include Capybara::DSL
Capybara.app = Sinatra::Application
