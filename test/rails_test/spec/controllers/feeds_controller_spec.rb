require File.dirname(__FILE__) + '/../spec_helper'

describe Muck::FeedsController do

  render_views
  
  describe "feeds controller" do
    
    describe "GET index" do
      before do
        get :index
      end
      it { should_not set_the_flash }
      it { should respond_with :success }
      it { should render_template :index }
    end

    describe "GET show" do
      before do
        @feed = Factory(:feed)
        get :show, :id => @feed.to_param, :format => 'html'
      end
      it { should_not set_the_flash }
      it { should respond_with :success }
      it { should render_template :show }
    end

    describe "logged in" do
      before do
        @admin = Factory(:user)
        @admin_role = Factory(:role, :rolename => 'administrator')
        @admin.roles << @admin_role
        activate_authlogic
        login_as @admin
      end
      
      describe "GET new" do
        before do
          get :new
        end
        it { should_not set_the_flash }
        it { should respond_with :success }
        it { should render_template :new }
      end

      describe "GET new_extended" do
        before do
          get :new_extended
        end
        it { should_not set_the_flash }
        it { should respond_with :success }
        it { should render_template :new_extended }
      end

      describe "POST create (simple)" do
        before do
          post :create, :feed => { :uri => TEST_RSS_URI }
        end
        it { should redirect_to( feed_path(assigns(:feed), :layout => true) ) }
        it { should set_the_flash.to(I18n.t('muck.services.feed_successfully_created', :uri => TEST_RSS_URI)) }
      end
      
      describe "POST create (advanced)" do
        before do
          post :create, :feed => { :uri => TEST_RSS_URI,
                                   :display_uri => 'http://www.example.com',
                                   :title => 'test feed long',
                                   :short_title => 'test feed',
                                   :description => 'foo bar'  }
        end
        it { should set_the_flash.to(I18n.t('muck.services.feed_successfully_created', :uri => TEST_RSS_URI)) }
      end

    end
    
  end

end