# == Schema Information
#
# Table name: oai_endpoints
#
#  id                  :integer(4)      not null, primary key
#  uri                 :string(2083)
#  display_uri         :string(2083)
#  metadata_prefix     :string(255)
#  title               :string(1000)
#  short_title         :string(100)
#  contributor_id      :integer(4)
#  status              :integer(4)
#  default_language_id :integer(4)
#  created_at          :datetime
#  updated_at          :datetime
#

require File.dirname(__FILE__) + '/../test_helper'

# Used to test muck_content_permission
class OaiEndpointTest < ActiveSupport::TestCase

  context "An oai endpoint instance" do
    setup do
      @oai_endpoint = Factory(:oai_endpoint)
    end
    
    subject { @oai_endpoint }
    
    should_belong_to :contributor
    should_belong_to :default_language
    
    should_validate_presence_of :uri
    
    should_have_named_scope :by_newest
    should_have_named_scope :banned
    should_have_named_scope :valid
    should_have_named_scope :by_title
    should_have_named_scope :recent
    
  end
  
  context "banned/unbanned" do
    setup do
      @feed = Factory(:feed)
    end
    should "be banned" do
      @feed.status = -1
      assert @feed.banned?
    end
    should "not be banned" do
      @feed.status = 0
      assert !@feed.banned?
    end
  end
  
end
