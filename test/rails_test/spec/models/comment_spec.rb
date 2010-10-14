# == Schema Information
#
# Table name: comments
#
#  id               :integer(4)      not null, primary key
#  commentable_id   :integer(4)      default(0)
#  commentable_type :string(15)      default("")
#  body             :text
#  user_id          :integer(4)
#  parent_id        :integer(4)
#  lft              :integer(4)
#  rgt              :integer(4)
#  is_denied        :integer(4)      default(0), not null
#  is_reviewed      :boolean(1)
#  created_at       :datetime
#  updated_at       :datetime
#

require File.dirname(__FILE__) + '/../spec_helper'

describe Comment do
  
  describe "activities" do
    before do
      @entry = Factory(:entry)
      @user = Factory(:user)
    end
    it "should add comment activity" do
      lambda{
        Comment.create(Factory.attributes_for(:comment, :commentable => @entry, :user => @user))          
      }.should change(Activity, :count).by(1)
    end
  end
end