require File.dirname(__FILE__) + '/../spec_helper'

describe Muck::TopicsController do

  render_views
  
  describe "topics controller" do

    before do
      bootstrap_services
    end
    
    describe "GET new" do
      before do
        get :new
      end
      it { should_not set_the_flash }
      it { should respond_with :success }
      it { should render_template :new }
    end

    describe "GET rss_discovery with term defined" do
      before do
        get :rss_discovery, :id => 'ruby,rails'
      end
      it { should_not set_the_flash }
      it { should respond_with :success }
      it { should render_template :rss_discovery }
    end
    
    describe "GET show with term defined" do
      before do
        get :show, :id => 'ruby,rails'
      end
      it { should_not set_the_flash }
      it { should respond_with :success }
      it { should render_template :show }
    end
  
    describe "GET show without terms" do
      before do
        get :show, :id => ' '
      end
      it { should set_the_flash.to(I18n.t('muck.services.no_terms_error')) }
      it { should redirect_to( new_topic_path ) }
    end
    
  end
  
end