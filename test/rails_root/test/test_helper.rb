$:.reject! { |e| e.include? 'TextMate' }
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'ruby-debug'
gem 'thoughtbot-factory_girl' # from github
require 'factory_girl'
require 'mocha'
require 'authlogic/test_case'
require 'active_record/fixtures'
require 'redgreen' rescue LoadError
require File.expand_path(File.dirname(__FILE__) + '/factories')
require File.join(File.dirname(__FILE__), 'shoulda_macros', 'controller')
require File.join(File.dirname(__FILE__), 'shoulda_macros', 'models')

class ActiveSupport::TestCase 
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = true

  TEST_URI = 'http://www.engadget.com'
  TEST_RSS_URI = 'http://www.engadget.com/rss.xml'
  TEST_USERNAME_TEMPLATE = 'http://feeds.delicious.com/v2/rss/{username}?count=100'
  
  include Authlogic::TestCase
  
  def login_as(user)
    success = UserSession.create(user)
    if !success
      errors = user.errors.full_messages.to_sentence
      message = 'User has not been activated' if !user.active?
      raise "could not login as #{user.to_param}.  Please make sure the user is valid. #{message} #{errors}"
    end
    UserSession.find
  end
  
  def assure_logout
    user_session = UserSession.find
    user_session.destroy if user_session
  end
  
  def ensure_flash(val)
    assert_contains flash.values, val, ", Flash: #{flash.inspect}"
  end
  
  def ensure_flash_contains(val)
    flash.values.each do |flv|
      return true if flv.include?(val)
    end
    false
  end
  
end

# turn off solr for tests
class ActsAsSolr::Post
  def self.execute(request)
    true
  end
end


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
  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
  
  ServiceCategory.delete_all
  yml = File.join(File.dirname(__FILE__), '..', '..', '..', 'db', 'bootstrap',"service_categories")
  Fixtures.new(Service.connection,"service_categories",ServiceCategory,yml).insert_fixtures
  
  Service.delete_all
  yml = File.join(File.dirname(__FILE__), '..', '..', '..', 'db', 'bootstrap',"services")
  Fixtures.new(Service.connection,"services",Service,yml).insert_fixtures
  
end

bootstrap_services