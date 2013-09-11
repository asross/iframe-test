ENV['RACK_ENV'] = 'test'
require_relative '../app.rb'

require 'rspec/autorun'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'pry'

include Capybara::DSL

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, inspector: 'open', js_errors: false)
end

Capybara.javascript_driver = :poltergeist
Capybara.app = Sinatra::Application
