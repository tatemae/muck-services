require File.dirname(__FILE__) + '/../spec_helper'

describe Muck::OaiEndpointsController do

  render_views
  
  describe "oai endpoints controller" do
    
    describe "logged in as admin" do
      before do
        @user = Factory(:user)
        activate_authlogic
        login_as @user
      end
      describe "GET new" do
        before do
          get :new
        end
        it { should_not set_the_flash }
        it { should respond_with :success }
        it { should render_template :new }
      end
      describe "POST create" do
        before do
          post :create, :oai_endpoint => { :uri => 'http://www.example.com', :title => 'example' }
        end
        it { should set_the_flash.to(I18n.t('muck.services.oai_endpoint_successfully_created')) }
        it { should redirect_to( oai_endpoint_url(assigns(:oai_endpoint)) ) }
      end
      describe "GET show" do
        before do
          @oai_endpoint = Factory(:oai_endpoint)
          get :show, :id => @oai_endpoint.to_param
        end
        it { should_not set_the_flash }
        it { should respond_with :success }
        it { should render_template :show }
      end
    end
  end

end