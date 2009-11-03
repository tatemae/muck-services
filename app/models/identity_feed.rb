# == Schema Information
#
# Table name: identity_feeds
#
#  id           :integer(4)      not null, primary key
#  feed_id      :integer(4)      not null
#  ownable_id   :integer(4)      not null
#  ownable_type :string(255)     not null
#

class IdentityFeed < ActiveRecord::Base
  belongs_to :ownable, :polymorphic => true
  belongs_to :feed
  
  validates_uniqueness_of :feed_id, :scope => [:ownable_id, :ownable_type]
  
  # Determines whether or not he given user can edit the identity feed
  def can_edit?(user)
    if ownable == user || user.admin?
      true
    else
      false
    end
  end
  
end
