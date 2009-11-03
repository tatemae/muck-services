# == Schema Information
#
# Table name: oai_endpoints
#
#  id              :integer(4)      not null, primary key
#  uri             :string(2083)
#  display_uri     :string(2083)
#  metadata_prefix :string(255)
#  title           :string(1000)
#  short_title     :string(100)
#
class OaiEndpoint < ActiveRecord::Base
  
  belongs_to :contributor, :class_name => 'User', :foreign_key => 'contributor_id'
  belongs_to :default_language, :class_name => 'Language', :foreign_key => 'default_language_id'
  
  validates_presence_of :uri
  
  named_scope :banned, :conditions => "status < 0"
  named_scope :valid, :conditions => "status >= 0"
  named_scope :by_title, :order => "title ASC"
  named_scope :recent, lambda { { :conditions => ['created_at > ?', 1.week.ago] } }
  named_scope :by_newest, :order => "created_at DESC", :include => [:default_language]
  
  attr_protected :status, :contributor_id
  
  def banned?
    self.status == MuckServices::Status::BANNED
  end

  def pending?
    self.status == MuckServices::Status::PENDING
  end

  def inform_admin
    ServicesMailer.deliver_notification_feed_added(self)
  end
  
end
