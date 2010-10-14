require File.dirname(__FILE__) + '/../spec_helper'

describe Muck::AggregationsController do
  
  render_views

  describe "aggregations controller" do
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
 
    describe "GET new" do
      before do
        get :new
      end
      it { should_not set_the_flash }
      it { should respond_with :success }
      it { should render_template :new }
    end
    
    describe "GET show" do
      before do
        @aggregation = Factory(:aggregation)
        get :show, :id => @aggregation.to_param
      end
      it { should_not set_the_flash }
      it { should respond_with :success }
      it { should render_template :show }
    end
    
    describe "GET edit" do
      before do
        @aggregation = Factory(:aggregation)
        get :edit, :id => @aggregation.to_param
      end
      it { should_not set_the_flash }
      it { should respond_with :success }
      it { should render_template :edit }
    end
    
    describe "POST create" do
      before do
        @term = 'example'
        post :create, :aggregation => { :terms => @term }
      end
      it { should redirect_to( edit_aggregation_path(assigns(:aggregation)) ) }
      it "should set the flash to add feeds" do
        ensure_flash_contains(I18n.t('muck.services.add_feeds_to_aggregation', :title => @term))
      end
    end
    
    describe "PUT update" do
      before do
        @aggregation = Factory(:aggregation)
        put :update, :id => @aggregation.to_param, :aggregation => { :terms => 'fish' }
      end
      it { should redirect_to( edit_user_aggregation_path(@aggregation.ownable, assigns(:aggregation)) ) }
      it "should set the flash to updated aggregation" do
        ensure_flash_contains(I18n.t('muck.services.aggregation_updated'))
      end
    end
    
    describe "DELETE destroy" do
      before do
        @aggregation = Factory(:aggregation)
        delete :destroy, :id => @aggregation.to_param
      end
      it { should redirect_to( user_aggregations_path(@aggregation.ownable) ) }
      it "should set the flash to deleted" do
        ensure_flash_contains(I18n.t('muck.services.aggregation_deleted', :title => ''))
      end
    end
    
  end
  
end