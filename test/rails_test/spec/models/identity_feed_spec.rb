# == Schema Information
#
# Table name: identity_feeds
#
#  id           :integer(4)      not null, primary key
#  feed_id      :integer(4)      not null
#  ownable_id   :integer(4)      not null
#  ownable_type :string(255)     not null
#

require File.dirname(__FILE__) + '/../spec_helper'

class IdentityFeedTest < ActiveSupport::TestCase
  describe "identity feed" do
    it { should belong_to :ownable }
    it { should belong_to :feed }
  end
end
