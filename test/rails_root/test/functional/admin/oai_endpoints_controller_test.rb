require File.dirname(__FILE__) + '/../../test_helper'

class Admin::Muck::OaiEndpointsControllerTest < ActionController::TestCase

  tests Admin::Muck::OaiEndpointsController

  context "admin oai endpoints controller" do
    
    should_require_login :index => :get, :login_url => '/login'
    
    context "logged in as admin" do
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
    end
  end

end