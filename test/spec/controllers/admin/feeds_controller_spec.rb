require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::Muck::FeedsController do
  
  render_views

  describe "admin feeds controller" do
    
    it { should require_login :index, :get }
    it { should require_login :update, :put }
    
    describe "logged in as admin" do
      before do
        @admin = Factory(:user)
        @admin_role = Factory(:role, :rolename => 'administrator')
        @admin.roles << @admin_role
        activate_authlogic
        login_as @admin
      end
      describe "GET index" do
        before do
          get :index
        end
        it { should_not set_the_flash }
        it { should respond_with :success }
        it { should render_template :index }
      end
      describe "PUT update" do
        before do
          @feed = Factory(:feed)
          put :update, :id => @feed, :status => true
        end
        it { should redirect_to( admin_feeds_path ) } 
      end
    end
  end

end