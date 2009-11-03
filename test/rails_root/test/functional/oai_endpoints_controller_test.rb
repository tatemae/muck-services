require File.dirname(__FILE__) + '/../test_helper'

class Muck::OaiEndpointsControllerTest < ActionController::TestCase

  tests Muck::OaiEndpointsController

  context "oai endpoints controller" do
    
    context "logged in as admin" do
      setup do
        @user = Factory(:user)
        activate_authlogic
        login_as @user
      end
      context "GET new" do
        setup do
          get :new
        end
        should_not_set_the_flash
        should_respond_with :success
        should_render_template :new
      end
      context "POST create" do
        setup do
          post :create, :oai_endpoint => { :uri => 'http://www.example.com', :title => 'example' }
        end
        should_set_the_flash_to(I18n.t('muck.services.oai_endpoint_successfully_created'))
        should_redirect_to("show oai endpoint") { oai_endpoint_url(assigns(:oai_endpoint)) }
      end
      context "GET show" do
        setup do
          @oai_endpoint = Factory(:oai_endpoint)
          get :show, :id => @oai_endpoint.to_param
        end
        should_not_set_the_flash
        should_respond_with :success
        should_render_template :show
      end
    end
  end

end