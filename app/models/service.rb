# == Schema Information
#
# Table name: services
#
#  id                  :integer(4)      not null, primary key
#  uri                 :string(2083)    default("")
#  name                :string(1000)    default("")
#  api_uri             :string(2083)    default("")
#  uri_template        :string(2083)    default("")
#  icon                :string(2083)    default("rss.gif")
#  sort                :integer(4)
#  requires_password   :boolean(1)
#  use_for             :string(255)
#  service_category_id :integer(4)
#  active              :boolean(1)      default(TRUE)
#  prompt              :string(255)
#  template            :string(255)
#  uri_data_template   :string(2083)    default("")
#  uri_key             :string(255)
#

class Service < ActiveRecord::Base
  
  belongs_to :service_category
  scope :sorted_id, order("id ASC")
  scope :sorted, order("sort ASC")
  scope :identity_services, where('use_for = ?', 'identity')
  scope :tag_services, where('use_for = ?', 'tags')
  scope :photo_services, where("service_categories.id = services.service_category_id AND service_categories.name = 'Photos'").includes('service_category')

  # Indicates whether service is primarily a photo service ie from flick, picasa, etc
  #
  # refresh_services:   Optional parameter indicating whether or not to reload values from the database before checking service type
  def photo?(refresh_services = false)
    Service.get_photo_services(refresh_services).include?(self)
  end
  
  # Indicates whether service is primarily a video service ie from youtube, etc
  #
  # refresh_services:   Optional parameter indicating whether or not to reload values from the database before checking service type
  def video?(refresh_services = false)
    Service.get_video_services(refresh_services).include?(self)
  end
  
  # Indicates whether service is primarily a bookmark service ie delicious, etc
  #
  # refresh_services:   Optional parameter indicating whether or not to reload values from the database before checking service type
  def bookmark?(refresh_services = false)
    Service.get_bookmark_services(refresh_services).include?(self)
  end
  
  # Indicates whether service is primarily music
  #
  # refresh_services:   Optional parameter indicating whether or not to reload values from the database before checking service type
  def music?(refresh_services = false)
    Service.get_music_services(refresh_services).include?(self)
  end
  
  # Indicates whether service is primarily news
  #
  # refresh_services:   Optional parameter indicating whether or not to reload values from the database before checking service type
  def news?(refresh_services = false)
    Service.get_news_services(refresh_services).include?(self)
  end
  
  # Indicates whether service is primarily blog related
  #
  # refresh_services:   Optional parameter indicating whether or not to reload values from the database before checking service type
  def blog?(refresh_services = false)
    Service.get_blog_services(refresh_services).include?(self)
  end
  
  # Indicates whether service is primarily search related
  #
  # refresh_services:   Optional parameter indicating whether or not to reload values from the database before checking service type
  def search?(refresh_services = false)
    Service.get_search_services(refresh_services).include?(self)
  end
  
  # Indicates whether service is general (ie not video, photo, music or bookmark)
  #
  # refresh_services:   Optional parameter indicating whether or not to reload values from the database before checking service type
  def general?(refresh_services = false)
    Service.get_general_services(refresh_services).include?(self)
  end
  
  def human_uri(tag)
    generate_tag_template_uri(tag, self.uri_template)
  end
  
  # Generate a uri for the current service
  def generate_tag_uri(tag)
    generate_tag_template_uri(tag, self.uri_data_template)
  end
  
  def generate_tag_template_uri(tag, uri_template)
    if self.name == 'Flickr'
      uri_template.sub("{tag}", tag.gsub('+',',')) # flickr wants a comma deliminated list of tags
    else
      uri_template.sub("{tag}", tag)
    end
  end
  
  # Requires settings in global_config.yml
  # For example:
  # amazon_access_key_id: 'some key from your account'
  # amazon_secret_access_key: 'the secret from your account'
  # amazon_associate_tag: 'optional'
  # ecs_to_rss_wishlist: "http://www.example.com/ecs_to_rss-wishlist.xslt"
  def generate_uris(username = '', password = '', uri = '')
    if self.name == 'Facebook'
      # Facebook can't just use feeds like everyone else.
      params = {}
      uris = []
      uri = "http://#{uri}" unless uri.starts_with?("http://")
      parsed_uri = URI.parse(uri)
      if parsed_uri.host == 'facebook.com' # check to make sure that the url provided really comes from Facebook
        if parsed_uri.query.blank?
          # Assume that they provided their Facebook Identity Uri (no feeds)
            uris << OpenStruct.new(:url => uri, :display_uri => uri, :title => I18n.t('muck.services.facebook'))
        else
          pairs = uri.split('?')[1].split('&')
          pairs.each do |pair|
            p = pair.split('=')
            params[p[0].to_sym] = p[1]
          end
          uris << OpenStruct.new(:url => "http://www.facebook.com/feeds/notifications.php?id=#{params[:id]}&viewer=#{params[:id]}&key=#{params[:key]}&format=rss20", :title => I18n.t('muck.services.facebook_notifications'))
          uris << OpenStruct.new(:url => "http://www.facebook.com/feeds/share_posts.php?id=#{params[:id]}&viewer=#{params[:id]}&key=#{params[:key]}&format=rss20", :title => I18n.t('muck.services.facebook_shares'))
          uris << OpenStruct.new(:url => "http://www.facebook.com/feeds/notes.php?id=#{params[:id]}&viewer=#{params[:id]}&key=#{params[:key]}&format=rss20", :title => I18n.t('muck.services.facebook_notes'))
        end
      end
      uris
    elsif self.name == 'Amazon'
      return [] if username.blank?
      # Have to build and sign Amazon wishlist rss feeds
      am = AmazonRequest.new(Secrets.amazon_access_key_id, Secrets.amazon_secret_access_key, Secrets.ecs_to_rss_wishlist, Secrets.amazon_associate_tag)
      results = am.get_amazon_feeds(username) # username needs to be the user's Amazon email
      results.collect { |result| OpenStruct.new(:url => result, :title => 'Amazon Wishlist') }
    elsif !self.uri_data_template.blank? && !username.blank?
      return [] if username.blank?
      uri = self.uri_data_template.sub("{username}", username)
      Feed.discover_feeds(uri)
    elsif !uri.blank?
      return [] if uri.blank?
      Feed.discover_feeds(uri)
    end
  end
  
  # Generates uris for 'tag' using all services where 'use_for' is 'tags'
  def self.generate_tag_uris(terms, selected_service_ids = nil)
    split_terms(terms).collect { |tag|
      get_tag_services(selected_service_ids).collect { |service| service.generate_tag_uri(tag) }
    }.flatten!
  end

  # creates a feed for a service with a username and optional password
  def self.create_tag_feeds_for_service(service, uri, username, password, contributor)
    uris = service.generate_uris(username, password, uri)
    uris.collect{ |u| Feed.find_or_create(u.url, u.title, username, password, service.id, contributor) } if uris
  end

  def self.build_photo_feeds(terms, user, service_ids = nil, refresh_services = false)
    if service_ids.nil?
      service_ids = get_photo_tag_services(refresh_services).map(&:id)
    else
      service_ids = make_int_array(service_ids) & get_photo_tag_services(refresh_services).map(&:id)
    end
    build_tag_feeds(terms, user, service_ids, refresh_services)
  end
  
  def self.build_video_feeds(terms, user, service_ids = nil, refresh_services = false)
    if service_ids.nil?
      service_ids = get_video_tag_services(refresh_services).map(&:id)
    else
      service_ids = make_int_array(service_ids) & get_video_tag_services(refresh_services).map(&:id)
    end
    build_tag_feeds(terms, user, service_ids, refresh_services)
  end
  
  def self.build_bookmark_feeds(terms, user, service_ids = nil, refresh_services = false)
    if service_ids.nil?
      service_ids = get_bookmark_tag_services(refresh_services).map(&:id)
    else
      service_ids = make_int_array(service_ids) & get_bookmark_tag_services(refresh_services).map(&:id)
    end
    build_tag_feeds(terms, user, service_ids, refresh_services)
  end
  
  def self.build_music_feeds(terms, user, service_ids = nil, refresh_services = false)
    if service_ids.nil?
      service_ids = get_music_tag_services(refresh_services).map(&:id)
    else
      service_ids = make_int_array(service_ids) & get_music_tag_services(refresh_services).map(&:id)
    end
    build_tag_feeds(terms, user, service_ids, refresh_services)
  end
  
  def self.build_news_feeds(terms, user, service_ids = nil, refresh_services = false)
    if service_ids.nil?
      service_ids = get_news_tag_services(refresh_services).map(&:id)
    else
      service_ids = make_int_array(service_ids) & get_news_tag_services(refresh_services).map(&:id)
    end
    build_tag_feeds(terms, user, service_ids, refresh_services)
  end
  
  def self.build_blog_feeds(terms, user, service_ids = nil, refresh_services = false)
    if service_ids.nil?
      service_ids = get_blog_tag_services(refresh_services).map(&:id)
    else
      service_ids = make_int_array(service_ids) & get_blog_tag_services(refresh_services).map(&:id)
    end
    build_tag_feeds(terms, user, service_ids, refresh_services)
  end
  
  def self.build_search_feeds(terms, user, service_ids = nil, refresh_services = false)
    if service_ids.nil?
      service_ids = get_search_tag_services(refresh_services).map(&:id)
    else
      service_ids = make_int_array(service_ids) & get_search_tag_services(refresh_services).map(&:id)
    end
    build_tag_feeds(terms, user, service_ids, refresh_services)
  end
  
  def self.build_general_feeds(terms, user, service_ids = nil, refresh_services = false)
    if service_ids.nil?
      service_ids = get_general_tag_services(refresh_services).map(&:id)
    else
      service_ids = make_int_array(service_ids) & get_general_tag_services(refresh_services).map(&:id)
    end
    build_tag_feeds(terms, user, service_ids, refresh_services)
  end
  
  
  
  # Get all photo services
  #
  # refresh_services:     By default all tag services are cached.  Setting this value to true
  #                       will result in the values being repopulated from the database  
  def self.get_photo_services(refresh_services = false)
    @photo_services = nil if refresh_services
    @photo_services ||= get_services(refresh_services).find_all{|service| !service.service_category.blank? && service.service_category.name == 'Photos' }
  end
  
  # Get all video services
  #
  # refresh_services:     By default all tag services are cached.  Setting this value to true
  #                       will result in the values being repopulated from the database
  def self.get_video_services(refresh_services = false)
    @video_services = nil if refresh_services
    @video_services ||= get_services(refresh_services).find_all{|service| !service.service_category.blank? && service.service_category.name == 'Videos' }
  end
  
  # Get all bookmark services
  #
  # refresh_services:     By default all tag services are cached.  Setting this value to true
  #                       will result in the values being repopulated from the database
  def self.get_bookmark_services(refresh_services = false)
    @bookmark_services = nil if refresh_services
    @bookmark_services ||= get_services(refresh_services).find_all{|service| !service.service_category.blank? && service.service_category.name == 'Bookmarks' }
  end
  
  # Get all music services
  #
  # refresh_services:     By default all tag services are cached.  Setting this value to true
  #                       will result in the values being repopulated from the database
  def self.get_music_services(refresh_services = false)
    @music_services = nil if refresh_services
    @music_services ||= get_services(refresh_services).find_all{|service| !service.service_category.blank? && service.service_category.name == 'Music' }
  end

  # Get all news services
  #
  # refresh_services:     By default all tag services are cached.  Setting this value to true
  #                       will result in the values being repopulated from the database
  def self.get_news_services(refresh_services = false)
    @news_services = nil if refresh_services
    @news_services ||= get_services(refresh_services).find_all{|service| !service.service_category.blank? && service.service_category.name == 'News' }
  end
  
  # Get all blog services
  #
  # refresh_services:     By default all tag services are cached.  Setting this value to true
  #                       will result in the values being repopulated from the database
  def self.get_blog_services(refresh_services = false)
    @blog_services = nil if refresh_services
    @blog_services ||= get_services(refresh_services).find_all{|service| !service.service_category.blank? && service.service_category.name == 'Blogging' }
  end
  
  # Get all search services
  #
  # refresh_services:     By default all tag services are cached.  Setting this value to true
  #                       will result in the values being repopulated from the database
  def self.get_search_services(refresh_services = false)
    @search_services = nil if refresh_services
    @search_services ||= get_services(refresh_services).find_all{|service| !service.service_category.blank? && service.service_category.name == 'Search' }
  end
  
  # Get all general services. These are all services except photo, video, bookmark and music.
  #
  # refresh_services:     By default all tag services are cached.  Setting this value to true
  #                       will result in the values being repopulated from the database  
  def self.get_general_services(refresh_services = false)
    @general_services = nil if refresh_services
    @general_services ||= get_services(refresh_services).find_all{|service| !non_general_categories.include?(service.service_category.name) }
  end
  
  
  
  # Get all photo services that are used to generate tag feeds
  #
  # refresh_services:     By default all tag services are cached.  Setting this value to true
  #                       will result in the values being repopulated from the database
  def self.get_photo_tag_services(refresh_services = false)
    @photo_services = nil if refresh_services
    @photo_services ||= get_tag_services(nil, refresh_services).find_all{|service| !service.service_category.blank? && service.service_category.name == 'Photos' }
  end

  # Get all video services that are used to generate tag feeds
  #
  # refresh_services:     By default all tag services are cached.  Setting this value to true
  #                       will result in the values being repopulated from the database  
  def self.get_video_tag_services(refresh_services = false)
    @video_services = nil if refresh_services
    @video_services ||= get_tag_services(nil, refresh_services).find_all{|service| !service.service_category.blank? && service.service_category.name == 'Videos' }
  end
  
  # Get all bookmark services that are used to generate tag feeds
  #
  # refresh_services:     By default all tag services are cached.  Setting this value to true
  #                       will result in the values being repopulated from the database
  def self.get_bookmark_tag_services(refresh_services = false)
    @bookmark_services = nil if refresh_services
    @bookmark_services ||= get_tag_services(nil, refresh_services).find_all{|service| !service.service_category.blank? && service.service_category.name == 'Bookmarks' }
  end
  
  # Get all music services that are used to generate tag feeds
  #
  # refresh_services:     By default all tag services are cached.  Setting this value to true
  #                       will result in the values being repopulated from the database
  def self.get_music_tag_services(refresh_services = false)
    @music_services = nil if refresh_services
    @music_services ||= get_tag_services(nil, refresh_services).find_all{|service| !service.service_category.blank? && service.service_category.name == 'Music' }
  end
  
  # Get all news services that are used to generate tag feeds
  #
  # refresh_services:     By default all tag services are cached.  Setting this value to true
  #                       will result in the values being repopulated from the database
  def self.get_news_tag_services(refresh_services = false)
    @news_services = nil if refresh_services
    @news_services ||= get_tag_services(nil, refresh_services).find_all{|service| !service.service_category.blank? && service.service_category.name == 'News' }
  end
  
  # Get all blog services that are used to generate tag feeds
  #
  # refresh_services:     By default all tag services are cached.  Setting this value to true
  #                       will result in the values being repopulated from the database
  def self.get_blog_tag_services(refresh_services = false)
    @blog_services = nil if refresh_services
    @blog_services ||= get_tag_services(nil, refresh_services).find_all{|service| !service.service_category.blank? && service.service_category.name == 'Blogging' }
  end
  
  # Get all search services that are used to generate tag feeds
  #
  # refresh_services:     By default all tag services are cached.  Setting this value to true
  #                       will result in the values being repopulated from the database
  def self.get_search_tag_services(refresh_services = false)
    @search_services = nil if refresh_services
    @search_services ||= get_tag_services(nil, refresh_services).find_all{|service| !service.service_category.blank? && service.service_category.name == 'Search' }
  end
  
  # Get all general services that are used to generate tag feeds
  #
  # refresh_services:     By default all tag services are cached.  Setting this value to true
  #                       will result in the values being repopulated from the database
  def self.get_general_tag_services(refresh_services = false)
    @general_services = nil if refresh_services
    @general_services ||= get_tag_services(nil, refresh_services).find_all{|service| !non_general_categories.include?(service.service_category.name) }
  end
  
  
  
  
  # Builds tag based feeds for the given term.  Feeds are not saved to the database. 
  #
  # terms:                Terms for which to generate feeds.  This value can be an array, a single string, 
  #                       or a list of items seperated by a comma.
  # user:                 User to attach the feed to.  This is the feed 'contributor.
  # selected_service_ids: ids for services to select.
  # refresh_services:     By default all tag services are cached.  Setting this value to true
  #                       will result in the values being repopulated from the database
  def self.build_tag_feeds(terms, user, selected_service_ids = nil, refresh_services = false)
    services = get_tag_services(selected_service_ids, refresh_services)
    split_terms(terms).collect { |tag|
      services.collect { |service| Feed.new(:uri => service.generate_tag_uri(tag),
                                            :display_uri => service.human_uri(tag),
                                            :title => I18n.t('muck.services.service_feed_name', :term => CGI.unescape(tag).humanize, :service => service.name),
                                            :service_id => service.id,
                                            :contributor_id => user) }
    }.flatten!
  end
  
  # Builds feeds (does not save them to the db) for the given term.  Note that this
  # method calls the url for each feed created to attempt auto discovery and so it 
  # can take a while to run.
  #
  # terms:                Terms for which to generate feeds.  This value can be an array, a single string, 
  #                       or a list of items seperated by a comma.
  # user:                 User to attach the feed to.  This is the feed 'contributor.
  # selected_service_ids: ids for services to select.
  def self.build_live_tag_feeds(terms, user, selected_service_ids = nil)
    uris = generate_tag_uris(terms, selected_service_ids)
    feed_uris = uris.collect { |uri| Feed.discover_feeds(uri)}
    feed_uris.collect { |feed| Feed.new(:uri => feed.url,
                                        :title => feed.title,
                                        :service_id => service.id,
                                        :contributor_id => user) }
  end
  
  # Create feeds for the given terms and save them to the database.
  # terms:                Terms for which to generate feeds.  This value can be an array, a single string,
  #                       or a list of items seperated by a comma.
  # user:                 User to attach the feed to.  This is the feed 'contributor.
  # selected_service_ids: ids for services to select.
  # refresh_services:     By default all tag services are cached.  Setting this value to true
  #                       will result in the values being repopulated from the database
  def self.create_tag_feeds(terms, user = nil, selected_service_ids = nil, refresh_services = false)
    services = get_tag_services(selected_service_ids, refresh_services)
    split_terms(terms).collect { |tag|
      services.collect { |service| Feed.find_or_create(service.generate_tag_uri(tag), tag, '', '', service.id, user, service.human_uri(tag)) }
    }.flatten!
  end
  
  # Splits terms using a comma.  This method also URI encodes all resulting terms
  # terms:                A string, array or comma delimited string of terms (tags).
  def self.split_terms(terms)
    return '' if terms.blank?
    terms = terms.split(',') unless terms.is_a?(Array)
    terms.collect { |tag| CGI.escape(tag.strip) }
  end
  
  # Gets all services with the specified service ids.  If selected_service_ids is not 
  # provided then this method will get all tag services 
  #
  # selected_service_ids: ids for services to select.
  # refresh_services:     By default all tag services are cached.  Setting this value to true
  #                       will result in the values being repopulated from the database
  def self.get_tag_services(selected_service_ids = nil, refresh_services = false)
    if selected_service_ids
      selected_service_ids.collect! { |service_id| service_id.to_i } # make sure the ids are ints
      Service.tag_services.find_all { |service| selected_service_ids.include?(service.id) }
    else
      if refresh_services
        @tag_services = Service.tag_services
      else
        @tag_services ||= Service.tag_services
      end
    end
  end
  
  # Selects and caches all services from the database.
  # 
  # refresh_services:     By default all tag services are cached.  Setting this value to true
  #                       will result in the values being repopulated from the database
  def self.get_services(refresh_services = false)
    @all_services = nil if refresh_services
    @all_services ||= Service.all
  end
  
  # Attempts to find a service object using a uri
  #
  # uri:              Uri to search for.  This method will attempt to all services for any part of the provided uri.
  # refresh_services: Forces a refresh of the services.  By default the services are cached for the duration of the request.
  def self.find_service_by_uri(uri, refresh_services = false)
    service = get_services(refresh_services).detect { |service| service.uri && service.uri.length > 0 && (uri.include?(service.uri) || service.uri.include?(uri)) }
    service ||= default_service
    service
  end
  
  # Turns all items in an array into integers.
  def self.make_int_array(a)
    a.collect{|i| i.to_i}
  end
  
  # Default service is RSS
  def self.default_service
    Service.find_by_name('rss') # this will return the default rss service
  end
  
  def self.non_general_categories
    ['Photos', 'Videos', 'Bookmarks', 'Music', 'News', 'Blogging', 'Search']
  end
  
end
