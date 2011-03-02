require File.dirname(__FILE__) + '/../spec_helper'

describe Muck::IdentityFeedsController do

  render_views
  
  describe "identity feeds controller" do
    
    before do
      @user = Factory(:user)
      @service = Factory(:service)
      activate_authlogic
      login_as @user
    end
    
    describe "GET index" do
      before do
        get :index, :user_id => @user.to_param
      end
      it { should_not set_the_flash }
      it { should respond_with :success }
      it { should render_template :index }
    end

    describe "GET new" do
      before do
        get :new, :user_id => @user.to_param, :service_id => @service.to_param
      end
      it { should_not set_the_flash }
      it { should respond_with :success }
      it { should render_template :new }
    end
    
    describe "POST create using bogus service and bogus uri" do
      before do
        @service = Factory(:service)
        @uri = 'http://www.example.com'
        post :create, :service_id => @service.to_param, :uri => @uri, :user_id => @user
      end
      it { should set_the_flash.to(I18n.t('muck.services.no_feeds_at_uri')) }
      it { should redirect_to( user_identity_feeds_url(@user.id) ) }
    end

    describe "POST create using bogus service and username" do
      before do
        @service = Factory(:service)
        post :create, :service_id => @service.to_param, :username => 'testingbogusservice', :user_id => @user
      end
      it { should set_the_flash.to(I18n.t('muck.services.please_specify_url')) }
      it { should redirect_to( user_identity_feeds_url(@user.id) ) }
    end
    
    describe "POST create using uri" do
      before do
        @service = Factory(:service)
        @uri = TEST_URI
        post :create, :service_id => @service.to_param, :uri => @uri, :user_id => @user
      end
      it "should set success in the flash" do
        ensure_flash_contains(I18n.t('muck.services.successfully_added_uri_feed'))
      end
    end
    
    describe "POST create using valid service username" do
      before do
        @service = Factory(:service, :uri_data_template => TEST_USERNAME_TEMPLATE)
        @username = 'jbasdf'
      end
      describe "html" do
        before do
          post :create, :service_id => @service.to_param, :username => @username, :user_id => @user
        end
        it { should set_the_flash.to(I18n.t('muck.services.successfully_added_username_feed', :service => '')) }
        it { should redirect_to( user_identity_feeds_url(@user.id) ) }
      end
      describe "json" do
        before do
          post :create, :service_id => @service.to_param, :username => @username, :user_id => @user, :format => 'json'
        end
        it { should respond_with :success }
      end
    end
    
    describe "POST create using valid service username - duplicate" do
      before do
        @service = Factory(:service, :uri_data_template => TEST_USERNAME_TEMPLATE)
        @username = 'jbasdf'
        post :create, :service_id => @service.to_param, :username => @username, :user_id => @user, :uri => 'http://www.example.com'
        post :create, :service_id => @service.to_param, :username => @username, :user_id => @user, :uri => 'http://www.example.com'
      end
      it { should set_the_flash.to(I18n.t('muck.services.already_added_username_feed', :service => '', :username => 'jbasdf')) } # really do have to hard code the string here.  @username is nil
      it { should redirect_to( user_identity_feeds_url(@user.id) ) } 
    end
    
    describe "POST create using uri - duplicate" do
      before do
        @service = Factory(:service)
        @uri = TEST_URI
        post :create, :service_id => @service.to_param, :uri => @uri, :user_id => @user
        post :create, :service_id => @service.to_param, :uri => @uri, :user_id => @user
      end
      it "should set already added in the flash" do
        ensure_flash_contains(I18n.t('muck.services.already_added_uri_feed', :uri => @uri))
      end
      it { should redirect_to( user_identity_feeds_url(@user.id) ) } 
    end
    
  end

end