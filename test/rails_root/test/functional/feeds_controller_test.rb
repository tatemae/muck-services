require File.dirname(__FILE__) + '/../test_helper'

class Muck::FeedsControllerTest < ActionController::TestCase

  tests Muck::FeedsController

  context "feeds controller" do
    
    context "GET index" do
      setup do
        get :index
      end
      should_not_set_the_flash
      should_respond_with :success
      should_render_template :index
    end

    context "GET show" do
      setup do
        @feed = Factory(:feed)
        get :show, :id => @feed.to_param, :format => 'html'
      end
      should_not_set_the_flash
      should_respond_with :success
      should_render_template :show
    end

    context "logged in" do
      setup do
        @admin = Factory(:user)
        @admin_role = Factory(:role, :rolename => 'administrator')
        @admin.roles << @admin_role
        activate_authlogic
        login_as @admin
      end
      
      context "GET new" do
        setup do
          get :new
        end
        should_not_set_the_flash
        should_respond_with :success
        should_render_template :new
      end

      context "GET new_extended" do
        setup do
          get :new_extended
        end
        should_not_set_the_flash
        should_respond_with :success
        should_render_template :new_extended
      end

      context "POST create (simple)" do
        setup do
          post :create, :feed => { :uri => TEST_RSS_URI }
        end
        should_redirect_to("feed") { feed_path(assigns(:feed), :layout => true) }
        should_set_the_flash_to(I18n.t('muck.services.feed_successfully_created', :uri => TEST_RSS_URI))
      end
      
      context "POST create (advanced)" do
        setup do
          post :create, :feed => { :uri => TEST_RSS_URI,
                                   :display_uri => 'http://www.example.com',
                                   :title => 'test feed long',
                                   :short_title => 'test feed',
                                   :description => 'foo bar'  }
        end
        should_set_the_flash_to(I18n.t('muck.services.feed_successfully_created', :uri => TEST_RSS_URI))
      end

    end
    
  end

end