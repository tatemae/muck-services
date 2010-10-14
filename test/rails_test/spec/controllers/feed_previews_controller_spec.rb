require File.dirname(__FILE__) + '/../spec_helper'

describe Muck::FeedPreviewsController do
  
  render_views

  describe "feed previews controller" do

    describe "GET new" do
      before do
        get :new
      end
      it { should_not set_the_flash }
      it { should respond_with :success }
      it { should render_template :new }
    end

    describe "POST to select_feeds" do
      before do
        post :select_feeds, :feed => { :uri => TEST_URI }
      end          
      it { should_not set_the_flash }
      it { should respond_with :success }
      it { should render_template :select_feeds }
      it "should return feeds for the given uri" do
        assert assigns(:feeds).length > 0
      end
    end
    
  end

end