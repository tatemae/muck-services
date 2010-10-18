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
  
  scope :newer_than, lambda { |*args| where("created_at > ?", args.first || DateTime.now) }
  scope :by_newest, order("created_at DESC")
  scope :entries_only, where("personal_recommendations.destination_type = 'Entry'")
  scope :users, where("personal_recommendations.destination_type = 'User'")
end
