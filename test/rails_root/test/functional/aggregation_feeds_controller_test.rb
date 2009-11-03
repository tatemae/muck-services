require File.dirname(__FILE__) + '/../test_helper'

class Muck::AggregationFeedsControllerTest < ActionController::TestCase

  tests Muck::AggregationFeedsController

  context "aggregation feeds controller" do
    setup do
      @aggregation = Factory(:aggregation)
      @feed = Factory(:feed)
      @aggregation.feeds << @feed
    end
    
    context "not logged in" do
      context "DELETE destroy" do
        setup do
          delete :destroy, :id => -1, :aggregation_id => @aggregation.id, :feed_id => @feed.id
        end
        should_redirect_to("login") { login_path }
        should "set the flash to can't delete" do
          ensure_flash_contains(I18n.t('muck.services.cant_modify_aggregation'))
        end
      end
      
      context "DELETE destroy json" do
        setup do
          delete :destroy, :id => -1, :aggregation_id => @aggregation.id, :feed_id => @feed.id, :format => 'json'
        end
        should_redirect_to("login") { login_path }
      end
      
    end
    
    context "logged in with permissions" do
      setup do
        @admin = Factory(:user)
        @admin_role = Factory(:role, :rolename => 'administrator')
        @admin.roles << @admin_role
        activate_authlogic
        login_as @admin
      end

      context "DELETE destroy" do
        setup do
          delete :destroy, :id => -1, :aggregation_id => @aggregation.id, :feed_id => @feed.id
        end
        should_redirect_to("aggregations path") { user_aggregation_path(@aggregation.ownable, @aggregation) }
        should "set the flash to deleted" do
          ensure_flash_contains(I18n.t('muck.services.feed_remove'))
        end
      end
      
      context "DELETE destroy json" do
        setup do
          delete :destroy, :id => -1, :aggregation_id => @aggregation.id, :feed_id => @feed.id, :format => 'json'
        end
        should_respond_with :success
        should "contain success:false in the result" do
          JSON.parse(@response.body)['success'] == true
        end
      end
      
    end
    
  end
  
end