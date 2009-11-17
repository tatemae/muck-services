# == Schema Information
#
# Table name: aggregations
#
#  id           :integer(4)      not null, primary key
#  terms         :string(255)
#  title        :string(255)
#  description  :text
#  top_tags     :text
#  created_at   :datetime
#  updated_at   :datetime
#  ownable_id   :integer(4)
#  ownable_type :string(255)
#

class Aggregation < ActiveRecord::Base
  unloadable

  has_friendly_id :terms, :use_slug => true
  
  belongs_to :ownable, :polymorphic => true
  has_many :aggregation_feeds, :conditions => ['feed_type = ?', 'Feed']
  has_many :aggregation_oai_endpoints, :conditions => ['feed_type = ?', 'OaiEndpoint']
  has_many :feeds, :through => :aggregation_feeds
  
  named_scope :by_title, :order => "title ASC"
  named_scope :recent, lambda { { :conditions => ['created_at > ?', 1.week.ago] } }
  named_scope :newest, :order => "created_at DESC"

    
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
  
  # Only add feeds that aren't already part of the aggregation
  def safe_add_feeds(new_feeds)
    new_feeds.each do |feed|
      begin
        self.feeds << feed
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
