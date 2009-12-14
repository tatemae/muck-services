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

require File.dirname(__FILE__) + '/../test_helper'

class AggregationTest < ActiveSupport::TestCase
  
  context "aggregation" do
    setup do
      @aggregation = Factory(:aggregation)
    end
    
    subject { @aggregation }
    
    should_belong_to :ownable
    should_have_many :aggregation_feeds
    should_have_many :feeds

    should_scope_by_title
    should_scope_recent
    should_scope_newest

    context "filter feed types" do
      setup do
        build_music_service
        Aggregation.delete_all
        @aggregation = Factory(:aggregation, :terms => 'autumn')
        @aggregation.add_feeds(nil, nil, true) # Generate all feeds
      end
      should "get all feeds" do
        assert @aggregation.all_feeds.length > 0
        assert @aggregation.all_feeds.any?{ |feed| feed.service.photo? }
        assert @aggregation.all_feeds.any?{ |feed| feed.service.video? }
        assert @aggregation.all_feeds.any?{ |feed| feed.service.bookmark? }
        assert @aggregation.all_feeds.any?{ |feed| feed.service.general? }
      end
      should "only get photo feeds" do
        assert @aggregation.photo_feeds(true).length > 0
        assert @aggregation.photo_feeds.all?{ |feed| feed.service.photo? }
      end
      should "only get video feeds" do
        assert @aggregation.video_feeds(true).length > 0
        assert @aggregation.video_feeds.all?{ |feed| feed.service.video? }
      end
      should "only get bookmark feeds" do
        assert @aggregation.bookmark_feeds(true).length > 0
        assert @aggregation.bookmark_feeds.all?{ |feed| feed.service.bookmark? }
      end
      should "only get music feeds" do
        assert @aggregation.music_feeds(true).length > 0
        assert @aggregation.music_feeds.all?{ |feed| feed.service.music? }
      end
      should "only get general feeds" do
        assert @aggregation.general_feeds(true).length > 0
        assert @aggregation.general_feeds.all?{ |feed| feed.service.general? }
      end
      
    end
    
    context "add_feeds_by_uri" do
      setup do
        @uris = ['http://www.example.com', 'http://www.justinball.com']
        @aggregation = Factory(:aggregation)
        @aggregation.add_feeds_by_uri(nil, @uris)
        @aggregation.reload
      end
      should "add feeds" do
        assert_equal @uris.length, @aggregation.feeds.length
      end
    end
    
  end
  
end
