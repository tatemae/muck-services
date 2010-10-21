# == Schema Information
#
# Table name: aggregations
#
#  id           :integer(4)      not null, primary key
#  terms        :string(255)
#  title        :string(255)
#  description  :text
#  top_tags     :text
#  created_at   :datetime
#  updated_at   :datetime
#  ownable_id   :integer(4)
#  ownable_type :string(255)
#  feed_count   :integer(4)      default(0)
#

class Aggregation < ActiveRecord::Base
  unloadable

  has_friendly_id :terms, :use_slug => true
  
  belongs_to :ownable, :polymorphic => true
  
  has_many :aggregation_feeds, :conditions => ['feed_type = ?', 'Feed']
  has_many :aggregation_oai_endpoints, :conditions => ['feed_type = ?', 'OaiEndpoint'], :source => 'aggregation_feeds'
  has_many :feeds, :through => :aggregation_feeds
  has_many :oai_endpoints, :through => :aggregation_feeds
  
  named_scope :by_title, :order => "title ASC"
  named_scope :recent, lambda { { :conditions => ['created_at > ?', 1.week.ago] } }
  named_scope :newest, :order => "created_at DESC"


  def self.global_feeds(order_field = 'title', ascending = 'true')
    allowed_fields = ['languages.english_name','status','entries_count','harvested_from_title','last_harvested_at','created_at','feed_contributor']
    order_direction = (ascending == 'false' ? ' DESC' : ' ASC')
    order_by = allowed_fields.include?(order_field) ? (order_field  + order_direction + ', title') : ('title ' + order_direction)

    Feed.find_by_sql("SELECT users.id feed_contributor_id, users.login feed_contributor, languages.english_name default_language_name, feeds.*, aggregation_id <=> 1 FROM aggregations " +
            "INNER JOIN aggregation_feeds ON aggregations.id = aggregation_feeds.aggregation_id " +
            "RIGHT OUTER JOIN feeds ON aggregation_feeds.feed_id = feeds.id " +
            "INNER JOIN languages ON feeds.default_language_id = languages.id " +
            "LEFT OUTER JOIN users ON feeds.contributor_id = users.id " +
#            "WHERE aggregations.title = 'global_feeds' AND feeds.status >= 0 " +
          "ORDER BY #{order_by}")
  end

  # Builds and then adds feeds for a given terms
  # user:         User to be associated with each feed.  Default is nil which makes each feed global.
  # service_ids:  An array of service ids.  Nil will generate a feed for every available service.
  # refresh_services:     By default all tag services are cached.  Setting this value to true
  #                       will result in the values being repopulated from the database
  def add_feeds(user = nil, service_ids = nil, refresh_services = false)
    safe_add_feeds(Service.create_tag_feeds(self.terms, user, service_ids, refresh_services))
  end
  
  def add_feeds_by_uri(user = nil, uris = nil)
    safe_add_feeds(Feed.create_tag_feeds(user, uris))
  end
  
  # Only add feeds that aren't already part of the aggregation.  This will setup the feed
  # as type 'Feed'.  It is important to add feeds using this method or the type won't be set.
  def safe_add_feeds(new_feeds, type = 'Feed')
    new_feeds.each do |feed|
      begin
        self.aggregation_feeds.create(:feed => feed, :feed_type => type)
      rescue ActiveRecord::RecordInvalid => ex
        # Throw away exception.  Feed already exists so we don't need to do anything.
      end
    end
    new_feeds
  end
  
  # Get only photo feeds
  def photo_feeds(refresh_services = false)
    all_feeds.find_all{ |feed| feed.service.photo?(refresh_services) rescue nil }
  end
  
  # Get only video feeds
  def video_feeds(refresh_services = false)
    all_feeds.find_all{ |feed| feed.service.video?(refresh_services) rescue nil }
  end
  
  # Get only bookmark feeds
  def bookmark_feeds(refresh_services = false)
    all_feeds.find_all{ |feed| feed.service.bookmark?(refresh_services) rescue nil }
  end

  # Get only music feeds
  def music_feeds(refresh_services = false)
    all_feeds.find_all{ |feed| feed.service.music?(refresh_services) rescue nil}
  end

  # Get only general feeds (exclude all specific feeds such as photos, videos, etc)
  def general_feeds(refresh_services = false)
    all_feeds.find_all{ |feed| feed.service.general?(refresh_services) rescue nil }
  end
  
  def all_feeds
    @all_feeds ||= self.feeds.find(:all, :include => :service)
  end

  # Determines whether or not he given user can edit the aggregation
  def can_edit?(user)
    if ownable == user || user.admin?
      true
    else
      false
    end
  end

  def self.global_feeds_id
    @@global_feeds_id = Aggregation.find_by_terms('global_feeds').id
  end
  
end
