# == Schema Information
#
# Table name: oai_endpoints
#
#  id                  :integer(4)      not null, primary key
#  uri                 :string(2083)
#  display_uri         :string(2083)
#  metadata_prefix     :string(255)
#  title               :string(1000)
#  short_title         :string(100)
#  contributor_id      :integer(4)
#  status              :integer(4)
#  default_language_id :integer(4)
#  created_at          :datetime
#  updated_at          :datetime
#
class OaiEndpoint < ActiveRecord::Base
  
  belongs_to :contributor, :class_name => 'User', :foreign_key => 'contributor_id'
  belongs_to :default_language, :class_name => 'Language', :foreign_key => 'default_language_id'
  
  validates_presence_of :uri
  
  scope :banned, where("status = ?", MuckServices::Status::BANNED)
  scope :valid, where("status >= 0")
  scope :by_title, order("title ASC")
  scope :newer_than, lambda { |*args| where("created_at > ?", args.first || DateTime.now) }
  scope :by_newest, order("created_at DESC").includes(:default_language)
  
  attr_protected :status, :contributor_id
  
  def banned?
    self.status == MuckServices::Status::BANNED
  end

  def pending?
    self.status == MuckServices::Status::PENDING
  end

  def inform_admin
    ServicesMailer.notification_feed_added(self).deliver
  end
  
end
