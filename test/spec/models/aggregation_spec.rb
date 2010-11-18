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

require File.dirname(__FILE__) + '/../spec_helper'

describe Aggregation do
  
  describe "aggregation" do
    before do
      @aggregation = Factory(:aggregation)
    end
    
    
    
    it { should belong_to :ownable }
    it { should have_many :aggregation_feeds }
    it { should have_many :feeds }

    it { should scope_by_title }
    it { should scope_newer_than }
    it { should scope_by_newest }

    describe "filter feed types" do
      before do
        build_music_service
        Aggregation.delete_all
        @aggregation = Factory(:aggregation, :terms => 'autumn')
        @aggregation.add_feeds(nil, nil, true) # Generate all feeds
      end
      it "should get all feeds" do
        assert @aggregation.all_feeds.length > 0
        assert @aggregation.all_feeds.any?{ |feed| feed.service.photo? }
        assert @aggregation.all_feeds.any?{ |feed| feed.service.video? }
        assert @aggregation.all_feeds.any?{ |feed| feed.service.bookmark? }
        assert @aggregation.all_feeds.any?{ |feed| feed.service.general? }
      end
      it "should only get photo feeds" do
        assert @aggregation.photo_feeds(true).length > 0
        assert @aggregation.photo_feeds.all?{ |feed| feed.service.photo? }
      end
      it "should only get video feeds" do
        assert @aggregation.video_feeds(true).length > 0
        assert @aggregation.video_feeds.all?{ |feed| feed.service.video? }
      end
      it "should only get bookmark feeds" do
        assert @aggregation.bookmark_feeds(true).length > 0
        assert @aggregation.bookmark_feeds.all?{ |feed| feed.service.bookmark? }
      end
      it "should only get music feeds" do
        assert @aggregation.music_feeds(true).length > 0
        assert @aggregation.music_feeds.all?{ |feed| feed.service.music? }
      end
      it "should only get general feeds" do
        assert @aggregation.general_feeds(true).length > 0
        assert @aggregation.general_feeds.all?{ |feed| feed.service.general? }
      end
      
    end
    
    describe "add_feeds_by_uri" do
      before do
        @uris = ['http://www.example.com', 'http://www.justinball.com']
        @aggregation = Factory(:aggregation)
        @aggregation.add_feeds_by_uri(nil, @uris)
        @aggregation.reload
      end
      it "should add feeds" do
        @aggregation.feeds.length.should == @uris.length
      end
    end
    
  end
  
end
