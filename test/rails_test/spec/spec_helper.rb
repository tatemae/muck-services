$:.reject! { |e| e.include? 'TextMate' }
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)

require 'muck_test_helper'
require File.expand_path(File.dirname(__FILE__) + '/factories')

TEST_URI = 'http://www.engadget.com'
TEST_RSS_URI = 'http://www.engadget.com/rss.xml'
TEST_USERNAME_TEMPLATE = 'http://feeds.delicious.com/v2/rss/{username}?count=100'
TEST_XML_URI = 'http://ocw.mit.edu/OcwWeb/rss/all/mit-allcourses.xml'

# Used to add in a music service since services.yml doesn't currently have any.
def build_music_service
  # We don't have any music services in the default services.yml so we build one here
  template = "http://example.com/{tag}.rss"
  uri_template = "http://example.com/{tag}"
  service_category = Factory(:service_category, :name => 'Music')
  Factory(:service, :uri_data_template => template, :uri_template => uri_template,  :use_for => 'tags', :service_category_id => service_category.id)
end
  
# load in the default data required to run the app
def bootstrap_services
  ActiveRecord::Base.establish_connection(::Rails.env)
  
  ServiceCategory.delete_all
  yml = File.join(File.dirname(__FILE__), '..', '..', '..', 'db', 'bootstrap',"service_categories")
  Fixtures.new(Service.connection,"service_categories",ServiceCategory,yml).insert_fixtures
  
  Service.delete_all
  yml = File.join(File.dirname(__FILE__), '..', '..', '..', 'db', 'bootstrap',"services")
  Fixtures.new(Service.connection,"services",Service,yml).insert_fixtures
  
end

bootstrap_services