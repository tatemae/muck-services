# == Schema Information
#
# Table name: shares
#
#  id            :integer(4)      not null, primary key
#  uri           :string(2083)    default(""), not null
#  title         :string(255)
#  message       :text
#  shared_by_id  :integer(4)      not null
#  created_at    :datetime
#  updated_at    :datetime
#  comment_count :integer(4)      default(0)
#  entry_id      :integer(4)
#

require File.dirname(__FILE__) + '/../spec_helper'

class ShareTest < ActiveSupport::TestCase

  describe "share instance" do
    before do
      @share = Factory(:share)
    end
    
    
    
    it { should belong_to :entry }
    it "should return entry for discover_attach_to" do
      @share.discover_attach_to.should == @share.entry
    end
  end
  
end
