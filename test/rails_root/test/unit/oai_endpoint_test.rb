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
    
    should_scope_by_title
    should_scope_recent
    should_scope_by_newest
    should_have_named_scope :banned
    should_have_named_scope :valid
    
    context "named scope" do
      context "banned" do
        # named_scope :banned, :conditions => ["status = ?", MuckServices::Status::BANNED]
        setup do
          @oai_endpoint = Factory(:oai_endpoint, :status => MuckServices::Status::BANNED)
          @oai_endpoint_not = Factory(:oai_endpoint)
        end
        should "find oai_endpoints that are banned" do
          assert OaiEndpoint.banned.include?(@oai_endpoint)
        end
        should "not find oai_endpoints that are not banned" do
          assert !OaiEndpoint.banned.include?(@oai_endpoint_not)
        end
      end
      context "valid" do
        # named_scope :valid, :conditions => "status >= 0", :include => [:default_language]
        setup do
          @oai_endpoint = Factory(:oai_endpoint, :status => 0)
          @oai_endpoint_not = Factory(:oai_endpoint, :status => MuckServices::Status::BANNED)
        end
        should "find valid oai_endpoints" do
          assert OaiEndpoint.valid.include?(@oai_endpoint)
        end
        should "not find invalid oai_endpoints" do
          assert !OaiEndpoint.valid.include?(@oai_endpoint_not)
        end
      end
    end
    
  end
  
  context "banned/unbanned" do
    setup do
      @oai_endpoint = Factory(:oai_endpoint)
    end
    should "be banned" do
      @oai_endpoint.status = -1
      assert @oai_endpoint.banned?
    end
    should "not be banned" do
      @oai_endpoint.status = 0
      assert !@oai_endpoint.banned?
    end
  end
  
end
