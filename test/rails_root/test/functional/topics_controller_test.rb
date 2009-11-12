require File.dirname(__FILE__) + '/../test_helper'

class Muck::TopicsControllerTest < ActionController::TestCase

  tests Muck::TopicsController

  context "topics controller" do

    setup do
      bootstrap_services
    end
    
    context "GET new" do
      setup do
        get :new
      end
      should_not_set_the_flash
      should_respond_with :success
      should_render_template :new
    end

    context "GET rss_discovery with term defined" do
      setup do
        get :rss_discovery, :id => 'ruby,rails'
      end
      should_not_set_the_flash
      should_respond_with :success
      should_render_template :rss_discovery
    end
    
    context "GET show with term defined" do
      setup do
        get :show, :id => 'ruby,rails'
      end
      should_not_set_the_flash
      should_respond_with :success
      should_render_template :show
    end
  
    context "GET show without terms" do
      setup do
        get :show, :id => ' '
      end
      should_set_the_flash_to(I18n.t('muck.services.no_terms_error'))
      should_redirect_to("new topic") { new_topic_path }
    end
    
  end
  
end