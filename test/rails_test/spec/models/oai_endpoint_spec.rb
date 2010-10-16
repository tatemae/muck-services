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

require File.dirname(__FILE__) + '/../spec_helper'

# Used to test muck_content_permission
describe OaiEndpoint do

  describe "An oai endpoint instance" do
    before do
      @oai_endpoint = Factory(:oai_endpoint)
    end
    
    it { should belong_to :contributor }
    it { should belong_to :default_language }
    it { should validate_presence_of :uri }
    it { should scope_by_title }
    it { should scope_newer_than }
    it { should scope_by_newest }

    describe "named scope" do
      describe "banned" do
        before do
          @oai_endpoint = Factory(:oai_endpoint, :status => MuckServices::Status::BANNED)
          @oai_endpoint_not = Factory(:oai_endpoint)
        end
        it "should find oai_endpoints that are banned" do
          OaiEndpoint.banned.should include(@oai_endpoint)
        end
        it "should not find oai_endpoints that are not banned" do
          OaiEndpoint.banned.should_not include(@oai_endpoint_not)
        end
      end
      describe "valid" do
        before do
          @oai_endpoint = Factory(:oai_endpoint, :status => 0)
          @oai_endpoint_not = Factory(:oai_endpoint, :status => MuckServices::Status::BANNED)
        end
        it "should find valid oai_endpoints" do
          OaiEndpoint.valid.should include(@oai_endpoint)
        end
        it "should not find invalid oai_endpoints" do
          OaiEndpoint.valid.should_not include(@oai_endpoint_not)
        end
      end
    end
    
  end
  
  describe "banned/unbanned" do
    before do
      @oai_endpoint = Factory(:oai_endpoint)
    end
    it "should be banned" do
      @oai_endpoint.status = -1
      @oai_endpoint.banned?.should be_true
    end
    it "should not be banned" do
      @oai_endpoint.status = 0
      @oai_endpoint.banned?.should be_false
    end
  end
  
end
