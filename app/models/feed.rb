# == Schema Information
#
# Table name: feeds
#
#  id                         :integer(4)      not null, primary key
#  uri                        :string(2083)
#  display_uri                :string(2083)
#  title                      :string(1000)
#  short_title                :string(100)
#  description                :text
#  tag_filter                 :string(1000)
#  top_tags                   :text
#  priority                   :integer(4)      default(10)
#  status                     :integer(4)      default(1)
#  last_requested_at          :datetime        default(Wed Jan 01 00:00:00 UTC 1969)
#  last_harvested_at          :datetime        default(Wed Jan 01 00:00:00 UTC 1969)
#  harvest_interval           :integer(4)      default(86400)
#  failed_requests            :integer(4)      default(0)
#  error_message              :text
#  service_id                 :integer(4)      default(0)
#  login                      :string(255)
#  password                   :string(255)
#  created_at                 :datetime
#  updated_at                 :datetime
#  entries_changed_at         :datetime
#  harvested_from_display_uri :string(2083)
#  harvested_from_title       :string(1000)
#  harvested_from_short_title :string(100)
#  entries_count              :integer(4)
#  default_language_id        :integer(4)      default(0)
#  default_grain_size         :string(255)     default("unknown")
#  contributor_id             :integer(4)
#  etag                       :string(255)
#

class Feed < ActiveRecord::Base

  include HTTParty
  format :xml

  validates_presence_of :uri, :unless => :is_website?
  validates_uniqueness_of :uri, :scope => [:contributor_id]

  has_many :feed_parents
  has_many :identity_feeds
  has_many :aggregation_feeds
  has_many :aggregations, :through => :aggregation_feeds
  has_many :entries, :dependent => :destroy
  belongs_to :contributor, :class_name => 'User', :foreign_key => 'contributor_id'
  belongs_to :default_language, :class_name => 'Language', :foreign_key => 'default_language_id'
  belongs_to :service
  
  scope :banned, where("status = ?", MuckServices::Status::BANNED)
  scope :valid, where("status >= 0").includes(:default_language)
  scope :by_title, order("title ASC").includes(:default_language)
  scope :newer_than, lambda { |*args| where("created_at > ?", args.first || DateTime.now) }
  scope :by_newest, order("created_at DESC").includes(:default_language)

  attr_protected :status, :last_requested_at, :last_harvested_at, :harvest_interval, :failed_requests,
                 :created_at, :updated_at, :entries_changed_at, :entries_count, :contributor_id
  
  # let uri be blank if display_uri is not blank. In that case the 'feed' is really a site rather than a feed.
  def is_website?
    self.uri.blank? && !self.display_uri.blank?
  end
  
  def banned?
    self.status == MuckServices::Status::BANNED
  end
  
  def pending?
    self.status == MuckServices::Status::PENDING
  end

  def inform_admin
    if MuckServices.configuration.inform_admin_of_global_feed && global?
      ServicesMailer.notification_feed_added(self).deliver # Global feed.  Email the admin to let them know a feed has been added
    end
  end
  
  # harvest_interval is stored in seconds
  # default is 86400 which is one day
  def harvest_interval_hours
    self.harvest_interval/3600
  end

  # Converts hours into seconds for harvest_interval
  def harvest_interval_hours=(interval)
    self.harvest_interval = interval * 3600
  end

  def harvest
    # check to see if the feed has changed
    feed = Feedzirra::Feed.fetch_and_parse(self.uri)
    feed.entries
    # updated_feed = Feedzirra::Feed.update(self)
    # if updated_feed.updated?
    #   updated_feed.new_entries # get new entries
    #   updated_feed.sanitize_entries! # clean up
    # end
  end

  # provided to make feed quack like a feedzirra feed
  def url
    display_uri
  end

  # provided to make feed quack like a feedzirra feed
  def feed_url
    uri
  end

  # provided to make feed quack like a feedzirra feed
  def last_modified
    entries_changed_at
  end
  
  # feeds that are not attached to anything become global to the site
  def global?
    self.feed_parents.empty? && self.identity_feeds.empty? && self.aggregations.empty?
  end
  
  # Checks to see if there is a reference to the feed in any of the relation tables.
  def in_use?
    feed = FeedParent.find_by_feed_id(self.id)
    return true if feed
    feed = IdentityFeed.find_by_feed_id(self.id)
    return true if feed
    feed = AggregationFeed.find_by_feed_id(self.id)
    return true if feed
    false
  end
  
  # This will delete a feed if there are no references to it
  def delete_if_unused(user)
    if user.id == contributor_id && !in_use?
      self.destroy
    else
      false
    end
  end
  
  # Gathers all available feed uris from the given uri and parses them into
  # feed objects
  def self.gather_information(uri)
    feeds = []
    @available_feeds = discover_feeds(uri)
    @available_feeds.each do |feed|
      feeds << new_from_feedzirra(fetch_feed(feed.url)) unless feed.blank?
    end
    feeds
  end

  # Gathers all available feed uris from the given uri and parses them into
  # feed objects
  def self.feeds_from_uri(uri, contributor = nil)
    feeds = []
    @available_feeds = discover_feeds(uri)
    @available_feeds.each do |feed|
      feeds << create_from_feedzirra(fetch_feed(feed.url), contributor) unless feed.blank?
    end
    feeds
  end
  
  # Fetch a remote feed
  def self.fetch_feed(url)
    return nil if url.blank?
    Feedzirra::Feed.fetch_and_parse(url)
  end
  
  # Turns a feed from feedzirra into a muck feed
  def self.new_from_feedzirra(feed)
    return if feed.blank?
    Feed.new(:short_title => feed.title,
             :title => feed.title,
             :display_uri => feed.url,
             :uri => feed.feed_url)
  end

  # Creates a feed from feedzirra into a muck feed
  def self.create_from_feedzirra(feed, contributor)
    return if feed.blank?
    Feed.find_or_create(feed.feed_url, feed.title, '', '', Service.find_service_by_uri(feed.url), contributor, feed.url)
  end
  
  # Looks for feeds from a given url
  def self.discover_feeds(uri)
    begin
      Feedbag.find(uri)
    rescue URI::InvalidURIError
      # if we aren't able to discover a feed then just return the original uri
      [Struct.new(:url => uri, :title => '')]
    end
  end
  
  # Attempts to build feeds from the provided uri. If that fails the uri is added as a website (a feed without a uri but with a display_uri)
  def self.make_feeds_or_website(uri, contributor, service_name = nil)
    return [] if uri.blank?
    feeds = Feed.feeds_from_uri(uri, contributor)
    if feeds.blank?
      # Couldn't find a feed. Create it as a website
      service = Service.find_by_name(service_name)
      service ||= Service.find_service_by_uri(uri)
      feeds = [Feed.find_or_create_as_website(uri, '', service, contributor)]
    end
    feeds
  end
  
  # Finds or creates a feed based on the url.  Any give feed uri should only exist once in the system
  def self.find_or_create(uri, title, username, password, service, contributor, display_uri = nil)
    if service.is_a?(Service)
      service_id = service.id
    else
      service_id = service
    end
    if contributor.is_a?(User)
      contributor_id = contributor.id
    else
      contributor_id = contributor
    end
    Feed.find_by_uri(uri) ||
      Feed.create(:uri => uri,
                 :harvest_interval => '01:00:00',
                 :last_harvested_at => Time.at(0),
                 :title => title,
                 :login => username,
                 :password => password,
                 :service_id => service_id,
                 :contributor_id => contributor_id,
                 :display_uri => display_uri)
  end
  
  # Finds or creates a feed based on the url.  Any give feed uri should only exist once in the system
  def self.find_or_create_as_website(display_uri, title, service, contributor)
    Feed.find_or_create(nil, title, nil, nil, service, contributor, display_uri)
  end
  
  # Create feeds for the given uris
  # user: User that will be set as the feed contributor
  # uris: An array of uris for which to create feeds
  # service: A default service to be associated with all the feeds.
  def self.create_tag_feeds(user = nil, uris = nil, service = nil)
    return [] if uris.blank?
    service ||= Service.default_service
    uris.collect { |uri| Feed.find_or_create(uri, '', '', '', service, user, uri) }
  end
  
  # Combines entries in a collection of feeds together and sorts the entries by date
  def self.combine_sort(feeds)
    return [] if feeds.nil? || feeds.blank?
    entries = feeds.collect{|feed| feed.entries}.flatten!
    sort_entries(entries)
  end
  
  # Sorts a collection of entries by date
  def self.sort_entries(entries)
    return [] if entries.nil? || entries.blank?
    entries.sort { |a,b| b.published_at <=> a.published_at }
  end

end
