require File.dirname(__FILE__) + '/../spec_helper'

describe Muck::AggregationFeedsController do
  
  render_views

  describe "aggregation feeds controller" do
    before do
      @aggregation = Factory(:aggregation)
      @feed = Factory(:feed)
      @aggregation.feeds << @feed
    end
    
    describe "not logged in" do
      describe "DELETE destroy" do
        before do
          delete :destroy, :id => -1, :aggregation_id => @aggregation.id, :feed_id => @feed.id
        end
        it { should redirect_to( login_path ) }
        it "should set the flash to can't delete" do
          ensure_flash_contains(I18n.t('muck.services.cant_modify_aggregation'))
        end
      end
      
      describe "DELETE destroy json" do
        before do
          delete :destroy, :id => -1, :aggregation_id => @aggregation.id, :feed_id => @feed.id, :format => 'json'
        end
        it "should render json indicating login required" do
          data = JSON.parse(response.body)
          data['logged_in'].should be_false
        end
      end
      
    end
    
    describe "logged in with permissions" do
      before do
        @admin = Factory(:user)
        @admin_role = Factory(:role, :rolename => 'administrator')
        @admin.roles << @admin_role
        activate_authlogic
        login_as @admin
      end

      describe "DELETE destroy" do
        before do
          delete :destroy, :id => -1, :aggregation_id => @aggregation.id, :feed_id => @feed.id
        end
        it { should redirect_to( user_aggregation_path(@aggregation.ownable, @aggregation) ) }
        it "should set the flash to deleted" do
          ensure_flash_contains(I18n.t('muck.services.feed_remove'))
        end
      end
      
      describe "DELETE destroy json" do
        before do
          delete :destroy, :id => -1, :aggregation_id => @aggregation.id, :feed_id => @feed.id, :format => 'json'
        end
        it { should respond_with :success }
        it "should contain success:false in the result" do
          JSON.parse(@response.body)['success'] == true
        end
      end
      
    end
    
  end
  
end