# == Schema Information
#
# Table name: aggregation_feeds
#
#  id             :integer(4)      not null, primary key
#  aggregation_id :integer(4)
#  feed_id        :integer(4)
#

require File.dirname(__FILE__) + '/../test_helper'

class AggregationFeedTest < ActiveSupport::TestCase
  
  context "aggregation feed" do
    setup do
      @aggregation_feed = Factory(:aggregation_feed)
    end
    
    subject { @aggregation_feed }
    
    should_belong_to :aggregation
    should_belong_to :feed
  end
  
end
