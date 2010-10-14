# == Schema Information
#
# Table name: aggregation_feeds
#
#  id             :integer(4)      not null, primary key
#  aggregation_id :integer(4)
#  feed_id        :integer(4)
#  feed_type      :string(255)     default("Feed")
#

require File.dirname(__FILE__) + '/../spec_helper'

class AggregationFeedTest < ActiveSupport::TestCase
  
  describe "aggregation feed" do
    before do
      @aggregation_feed = Factory(:aggregation_feed)
    end
    
    
    
    it { should belong_to :aggregation }
    it { should belong_to :feed }
  end
  
end
