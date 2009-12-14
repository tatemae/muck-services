RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

# Load a global constant so the initializers can use them
require 'ostruct'
require 'yaml'
::GlobalConfig = OpenStruct.new(YAML.load_file("#{RAILS_ROOT}/config/global_config.yml")[RAILS_ENV])

class TestGemLocator < Rails::Plugin::Locator
  def plugins
    Rails::Plugin.new(File.join(File.dirname(__FILE__), *%w(.. .. ..)))
  end 
end

Rails::Initializer.run do |config|
  config.time_zone = 'UTC'
  config.gem "will_paginate"
  config.gem "authlogic"
  config.gem "searchlogic"
  config.gem "bcrypt-ruby", :lib => "bcrypt", :version => ">=2.0.5"
  config.gem "acts-as-taggable-on"
  config.gem "awesome_nested_set"
  config.gem "muck-feedbag", :lib => "feedbag"
  config.gem "feedzirra"
  config.gem "httparty"
  config.gem "river"
  config.gem "overlord"
  config.gem "friendly_id"
  config.gem "sanitize"
  config.gem "geokit"
  config.gem 'muck-engine', :lib => 'muck_engine'
  config.gem 'muck-users', :lib => 'muck_users'
  config.gem 'muck-profiles', :lib => 'muck_profiles'
  config.gem 'muck-comments', :lib => 'muck_comments'
  config.gem 'muck-activities', :lib => 'muck_activities'
  config.gem 'muck-shares', :lib => 'muck_shares'
  config.gem 'muck-solr', :lib => 'acts_as_solr'
  config.gem 'muck-raker', :lib => 'muck_raker'
  config.plugin_locators << TestGemLocator
end