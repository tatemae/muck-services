require File.dirname(__FILE__) + '/../test_helper'

class Muck::AggregationsControllerTest < ActionController::TestCase

  tests Muck::AggregationsController

  context "aggregations controller" do
    setup do
      @admin = Factory(:user)
      @admin_role = Factory(:role, :rolename => 'administrator')
      @admin.roles << @admin_role
      activate_authlogic
      login_as @admin
    end
   
    context "GET index" do
      setup do
        get :index
      end
      should_not_set_the_flash
      should_respond_with :success
      should_render_template :index
    end
 
    context "GET new" do
      setup do
        get :new
      end
      should_not_set_the_flash
      should_respond_with :success
      should_render_template :new
    end
    
    context "GET show" do
      setup do
        @aggregation = Factory(:aggregation)
        get :show, :id => @aggregation.to_param
      end
      should_not_set_the_flash
      should_respond_with :success
      should_render_template :show
    end
    
    context "GET edit" do
      setup do
        @aggregation = Factory(:aggregation)
        get :edit, :id => @aggregation.to_param
      end
      should_not_set_the_flash
      should_respond_with :success
      should_render_template :edit
    end
    
    context "POST create" do
      setup do
        @term = 'example'
        post :create, :aggregation => { :terms => @term }
      end
      should_redirect_to("aggregation") { edit_aggregation_path(assigns(:aggregation)) }
      should "set the flash to add feeds" do
        ensure_flash_contains(I18n.t('muck.services.add_feeds_to_aggregation', :title => @term))
      end
    end
    
    context "PUT update" do
      setup do
        @aggregation = Factory(:aggregation)
        put :update, :id => @aggregation.to_param, :aggregation => { :terms => 'fish' }
      end
      should_redirect_to("aggregation") { edit_user_aggregation_path(@aggregation.ownable, assigns(:aggregation)) }
      should "set the flash to updated aggregation" do
        ensure_flash_contains(I18n.t('muck.services.aggregation_updated'))
      end
    end
    
    context "DELETE destroy" do
      setup do
        @aggregation = Factory(:aggregation)
        delete :destroy, :id => @aggregation.to_param
      end
      should_redirect_to("aggregations") { user_aggregations_path(@aggregation.ownable) }
      should "set the flash to deleted" do
        ensure_flash_contains(I18n.t('muck.services.aggregation_deleted', :title => ''))
      end
    end
    
  end
  
end