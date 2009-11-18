# == Schema Information
#
# Table name: aggregation_feeds
#
#  id             :integer(4)      not null, primary key
#  aggregation_id :integer(4)
#  feed_id        :integer(4)
#  feed_type      :string(255)     default("Feed")
#

class AggregationFeed < ActiveRecord::Base
  belongs_to :aggregation, :counter_cache => 'feed_count', :touch => true
  belongs_to :feed
  validates_uniqueness_of :feed_id, :scope => :aggregation_id
end
