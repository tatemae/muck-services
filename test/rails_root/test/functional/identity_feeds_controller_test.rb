require File.dirname(__FILE__) + '/../test_helper'

class Muck::IdentityFeedsControllerTest < ActionController::TestCase

  tests Muck::IdentityFeedsController

  context "identity feeds controller" do
    
    setup do
      @user = Factory(:user)
      @service = Factory(:service)
      activate_authlogic
      login_as @user
    end
    
    context "GET index" do
      setup do
        get :index, :user_id => @user.to_param
      end
      should_not_set_the_flash
      should_respond_with :success
      should_render_template :index
    end

    context "GET new" do
      setup do
        get :new, :user_id => @user.to_param, :service_id => @service.to_param
      end
      should_not_set_the_flash
      should_respond_with :success
      should_render_template :new
    end
    
    context "POST create using bogus service and bogus uri" do
      setup do
        @service = Factory(:service)
        @uri = 'http://www.example.com'
        post :create, :service_id => @service.to_param, :uri => @uri, :user_id => @user
      end
      should_set_the_flash_to(I18n.t('muck.services.no_feeds_at_uri'))
      should_redirect_to("parent") { user_identity_feeds_url(@user.id) }
    end

    context "POST create using bogus service and username" do
      setup do
        @service = Factory(:service)
        post :create, :service_id => @service.to_param, :username => 'test', :user_id => @user, :uri => 'http://www.example.com'
      end
      should_set_the_flash_to(I18n.t('muck.services.no_feeds_from_username'))
      should_redirect_to("parent") { user_identity_feeds_url(@user.id) }
    end
    
    context "POST create using uri" do
      setup do
        @service = Factory(:service)
        @uri = TEST_URI
        post :create, :service_id => @service.to_param, :uri => @uri, :user_id => @user
      end
      should "set success in the flash" do
        ensure_flash_contains(I18n.t('muck.services.successfully_added_uri_feed'))
      end
    end
    
    context "POST create using valid service username" do
      setup do
        @service = Factory(:service, :uri_data_template => TEST_USERNAME_TEMPLATE)
        @username = 'jbasdf'
      end
      context "html" do
        setup do
          post :create, :service_id => @service.to_param, :username => @username, :user_id => @user, :uri => 'http://www.example.com'
        end
        should_set_the_flash_to(I18n.t('muck.services.successfully_added_username_feed', :service => ''))
        should_redirect_to("parent") { user_identity_feeds_url(@user.id) }
      end
      context "json" do
        setup do
          post :create, :service_id => @service.to_param, :username => @username, :user_id => @user, :format => 'json'
        end
        should_respond_with :success
      end
    end
    
    context "POST create using valid service username - duplicate" do
      setup do
        @service = Factory(:service, :uri_data_template => TEST_USERNAME_TEMPLATE)
        @username = 'jbasdf'
        post :create, :service_id => @service.to_param, :username => @username, :user_id => @user, :uri => 'http://www.example.com'
        post :create, :service_id => @service.to_param, :username => @username, :user_id => @user, :uri => 'http://www.example.com'
      end
      should_set_the_flash_to(I18n.t('muck.services.already_added_username_feed', :service => '', :username => 'jbasdf')) # really do have to hard code the string here.  @username is nil
      should_redirect_to("parent") { user_identity_feeds_url(@user.id) } 
    end
    
    context "POST create using uri - duplicate" do
      setup do
        @service = Factory(:service)
        @uri = TEST_URI
        post :create, :service_id => @service.to_param, :uri => @uri, :user_id => @user
        post :create, :service_id => @service.to_param, :uri => @uri, :user_id => @user
      end
      should "set already added in the flash" do
        ensure_flash_contains(I18n.t('muck.services.already_added_uri_feed', :uri => @uri))
      end
      should_redirect_to("parent") { user_identity_feeds_url(@user.id) } 
    end
    
  end

end