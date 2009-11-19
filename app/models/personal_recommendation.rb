# == Schema Information
#
# Table name: personal_recommendations
#
#  id                          :integer(4)      not null, primary key
#  personal_recommendable_id   :integer(4)
#  personal_recommendable_type :string(255)
#  destination_id              :integer(4)
#  destination_type            :string(255)
#  relevance                   :float
#  created_at                  :datetime
#  visited_at                  :datetime
#

class PersonalRecommendation < ActiveRecord::Base
  
  belongs_to :personal_recommendable, :polymorphic => true
  belongs_to :destination, :polymorphic => true
  
  named_scope :limited, lambda { |num| { :limit => num } }
  named_scope :recent, lambda { { :conditions => ['created_at > ?', 1.week.ago] } }
  named_scope :newest, :order => "created_at DESC"
  named_scope :entries_only, :conditions => ["personal_recommendations.destination_type = 'Entry'"]
  named_scope :users, :conditions => ["personal_recommendations.destination_type = 'User'"]
end
