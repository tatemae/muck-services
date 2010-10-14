# == Schema Information
#
# Table name: feeds
#
#  id                         :integer(4)      not null, primary key
#  uri                        :string(2083)
#  display_uri                :string(2083)
#  title                      :string(1000)
#  short_title                :string(100)
#  description                :text
#  tag_filter                 :string(1000)
#  top_tags                   :text
#  priority                   :integer(4)      default(10)
#  status                     :integer(4)      default(1)
#  last_requested_at          :datetime        default(Wed Jan 01 00:00:00 UTC 1969)
#  last_harvested_at          :datetime        default(Wed Jan 01 00:00:00 UTC 1969)
#  harvest_interval           :integer(4)      default(86400)
#  failed_requests            :integer(4)      default(0)
#  error_message              :text
#  service_id                 :integer(4)      default(0)
#  login                      :string(255)
#  password                   :string(255)
#  created_at                 :datetime
#  updated_at                 :datetime
#  entries_changed_at         :datetime
#  harvested_from_display_uri :string(2083)
#  harvested_from_title       :string(1000)
#  harvested_from_short_title :string(100)
#  entries_count              :integer(4)
#  default_language_id        :integer(4)      default(0)
#  default_grain_size         :string(255)     default("unknown")
#  contributor_id             :integer(4)
#  etag                       :string(255)
#

require File.dirname(__FILE__) + '/../spec_helper'

# Used to test muck_content_permission
class FeedTest < ActiveSupport::TestCase

  describe "A feed instance" do
    before do
      @feed = Factory(:feed)
    end
    
    
    
    it { should have_many :feed_parents }
    it { should have_many :entries }
    it { should belong_to :contributor }
    it { should belong_to :default_language }
    it { should belong_to :service }
    
    it { should validate_presence_of :uri }
    it { should validate_uniqueness_of :uri }
    
    should_scope_by_title
    it { should scope_newer_than }
    it { should scope_by_newest }
    
    it "should set 24 hours as default interval" do
      24.should == @feed.harvest_interval_hours
    end
    
    it "should set harvest interval by hours" do
      @feed.harvest_interval_hours = 10
      10 * 3600.should == @feed.harvest_interval
    end
    
    describe "named scope" do
      describe "banned" do
        # named_scope :banned, :conditions => ["status = ?", MuckServices::Status::BANNED]
        before do
          @feed = Factory(:feed, :status => MuckServices::Status::BANNED)
          @feed_not = Factory(:feed)
        end
        it "should find feeds that are banned" do
          Feed.banned.should include(@feed)
        end
        it "should not find feeds that are not banned" do
          !Feed.banned.should include(@feed_not)
        end
      end
      describe "valid" do
        # named_scope :valid, :conditions => "status >= 0", :include => [:default_language]
        before do
          @feed = Factory(:feed, :status => 0)
          @feed_not = Factory(:feed, :status => MuckServices::Status::BANNED)
        end
        it "should find valid feeds" do
          Feed.valid.should include(@feed)
        end
        it "should not find invalid feeds" do
          !Feed.valid.should include(@feed_not)
        end
      end
    end
    
  end
  
  describe "Feed status" do
    before do
      @feed = Factory(:feed)
    end
    it "should be banned" do
      @feed.status = MuckServices::Status::BANNED
      assert @feed.banned?
    end
    it "should be approved" do
      @feed.status = MuckServices::Status::APPROVED
      assert !@feed.banned?
    end
    it "should be pending" do
      @feed.status = MuckServices::Status::PENDING
      assert @feed.pending?
    end
  end
  
  describe "Get feed information" do
    it "shouldGet feed information" do
      Feed.gather_information(TEST_URI)
    end
    it "shouldDiscover feeds from url" do
      Feed.discover_feeds(TEST_URI)
    end
    it "shouldDiscover feeds from xml url" do
      Feed.discover_feeds(TEST_XML_URI)[0].url.should == TEST_XML_URI
    end
  end
  
  describe "Harvest feed" do
    before do
      @feed = Factory(:feed, :uri => TEST_RSS_URI, :display_uri => TEST_URI)
    end
    it "should get new entries" do
      entries = @feed.harvest
      assert entries.length > 0
    end
  end
  
  describe "Delete feed if unused" do
    before do
      @user = Factory(:user)
      @identity_user = Factory(:user)
      @delete_feed = Factory(:feed, :contributor => @user)
      @dont_delete_feed = Factory(:feed, :contributor => @user)
      @identity_user.own_feeds << @dont_delete_feed
    end
    it "should delete feed" do
      assert @delete_feed.delete_if_unused(@user)
    end
    it "should not delete feed" do
      assert !@dont_delete_feed.delete_if_unused(@user)
    end
  end
  
  describe "global feed and references" do
    before do
      @global_feed = Factory(:feed)
      @user = Factory(:user)
      @feed = Factory(:feed)
      @user.feeds << @feed
      @feed.reload
      @identity_feed = Factory(:feed)
      @user.own_feeds << @identity_feed
      @identity_feed.reload
      @aggregation_feed = Factory(:feed)
      @aggregation = Factory(:aggregation, :ownable => @user)
      @aggregation.feeds << @aggregation_feed
    end

    describe "referenced feed" do
      describe "feed" do
        it "should be non-global" do
          assert !@feed.global?
        end
        it "should be in use" do
          assert @feed.in_use?
        end
      end
      describe "identity feed" do
        it "should be non-global" do
          assert !@identity_feed.global?
        end
        it "should be in use" do
          assert @identity_feed.in_use?
        end
      end
      describe "aggregation feed" do
        it "should be non-global" do
          assert !@aggregation_feed.global?
        end
        it "should be in use" do
          assert @aggregation_feed.in_use?
        end
      end
    end
    describe "global feed" do
      it "should be a global feed" do
        assert @global_feed.global?
      end
      it "should not be in use" do
        assert !@global_feed.in_use?
      end
    end
  end
  
end
