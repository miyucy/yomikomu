ENV['BUNDLE_GEMFILE'] = __dir__ + '/Gemfile'
require 'bundler/setup'
Bundler.require
require 'rails/all'
p Rails::Application
