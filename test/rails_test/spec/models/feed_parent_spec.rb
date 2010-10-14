# == Schema Information
#
# Table name: feed_parents
#
#  id           :integer(4)      not null, primary key
#  feed_id      :integer(4)
#  ownable_id   :integer(4)
#  ownable_type :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

require File.dirname(__FILE__) + '/../spec_helper'

class FeedParentTest < ActiveSupport::TestCase

  describe "A feed parent instance" do
    it { should belong_to :feed }
    it { should belong_to :ownable }
  end
  
end
