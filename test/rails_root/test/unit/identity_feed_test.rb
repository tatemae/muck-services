# == Schema Information
#
# Table name: identity_feeds
#
#  id           :integer(4)      not null, primary key
#  feed_id      :integer(4)      not null
#  ownable_id   :integer(4)      not null
#  ownable_type :string(255)     not null
#

require File.dirname(__FILE__) + '/../test_helper'

class IdentityFeedTest < ActiveSupport::TestCase
  context "identity feed" do
    should_belong_to :ownable
    should_belong_to :feed
  end
end
