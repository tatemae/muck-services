require File.dirname(__FILE__) + '/../spec_helper'

describe Muck::VisitsController do
  
  render_views

  describe "visits controller" do

    describe "GET show" do
      before do
        @entry = Factory(:entry)
        get :show, :id => @entry.to_param, :format => 'html'
      end
      it { should_not set_the_flash }
      it { should respond_with :success }
      it { should render_template :show }
    end

  end

end