require 'ostruct'

module MuckServices
  
  def self.configuration
    # In case the user doesn't setup a configure block we can always return default settings:
    @configuration ||= Configuration.new
  end
  
  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    
    attr_accessor :enable_services_shares
    attr_accessor :inform_admin_of_global_feed
    attr_accessor :enable_services_comments
    attr_accessor :render_feeds_client_side
    attr_accessor :show_google_search           # Determines whether or not a google search is displayed on the topic page
    attr_accessor :combine_feeds_on_server      # Combines feeds loaded on the server
    attr_accessor :load_feeds_on_server         # Determines whether feeds on a topic page are loaded on the server or the client.  Loading on the server can take a while
    
    def initialize
      self.enable_services_shares = true
      self.inform_admin_of_global_feed = true
      self.enable_services_comments = true
      self.render_feeds_client_side = true
      self.show_google_search = true
      self.combine_feeds_on_server = false
      self.load_feeds_on_server = false
    end
    
  end
end