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

require File.dirname(__FILE__) + '/../test_helper'

# Used to test muck_content_permission
class FeedTest < ActiveSupport::TestCase

  context "A feed instance" do
    setup do
      @feed = Factory(:feed)
    end
    
    subject { @feed }
    
    should_have_many :feed_parents
    should_have_many :entries
    should_belong_to :contributor
    should_belong_to :default_language
    should_belong_to :service
    
    should_validate_presence_of :uri
    
    should_scope_by_title
    should_scope_recent
    should_scope_by_newest
    
    should_have_named_scope :banned
    should_have_named_scope :valid
    
    should "set 24 hours as default interval" do
      assert_equal @feed.harvest_interval_hours, 24
    end
    
    should "set harvest interval by hours" do
      @feed.harvest_interval_hours = 10
      assert_equal @feed.harvest_interval, 10 * 3600
    end
    
  end
  
  context "Feed status" do
    setup do
      @feed = Factory(:feed)
    end
    should "be banned" do
      @feed.status = MuckServices::Status::BANNED
      assert @feed.banned?
    end
    should "be approved" do
      @feed.status = MuckServices::Status::APPROVED
      assert !@feed.banned?
    end
    should "be pending" do
      @feed.status = MuckServices::Status::PENDING
      assert @feed.pending?
    end
  end
  
  context "Get feed information" do
    should "Get feed information" do
      Feed.gather_information(TEST_URI)
    end
    should "Discover feeds from url" do
      Feed.discover_feeds(TEST_URI)
    end
  end
  
  context "Harvest feed" do
    setup do
      @feed = Factory(:feed, :uri => TEST_RSS_URI, :display_uri => TEST_URI)
    end
    should "get new entries" do
      entries = @feed.harvest
      assert entries.length > 0
    end
  end
  
  context "Delete feed if unused" do
    setup do
      @user = Factory(:user)
      @identity_user = Factory(:user)
      @delete_feed = Factory(:feed, :contributor => @user)
      @dont_delete_feed = Factory(:feed, :contributor => @user)
      @identity_user.own_feeds << @dont_delete_feed
    end
    should "delete feed" do
      assert @delete_feed.delete_if_unused(@user)
    end
    should "not delete feed" do
      assert !@dont_delete_feed.delete_if_unused(@user)
    end
  end
  
  context "global feed and references" do
    setup do
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

    context "referenced feed" do
      context "feed" do
        should "be non-global" do
          assert !@feed.global?
        end
        should "be in use" do
          assert @feed.in_use?
        end
      end
      context "identity feed" do
        should "be non-global" do
          assert !@identity_feed.global?
        end
        should "be in use" do
          assert @identity_feed.in_use?
        end
      end
      context "aggregation feed" do
        should "be non-global" do
          assert !@aggregation_feed.global?
        end
        should "be in use" do
          assert @aggregation_feed.in_use?
        end
      end
    end
    context "global feed" do
      should "be a global feed" do
        assert @global_feed.global?
      end
      should "not be in use" do
        assert !@global_feed.in_use?
      end
    end
  end
  
end
