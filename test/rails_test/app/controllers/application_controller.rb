class ApplicationController < ActionController::Base
  
  helper :all
  protect_from_forgery

  layout 'default'
  
  before_filter :setup_paging
  before_filter :set_will_paginate_string
  
  protected
    # called by Admin::Muck::BaseController to check whether or not the
    # user should have access to the admin UI
    def admin_access?
      admin?
    end
    
    # called by Admin::Muck::BaseController to check whether or not the
    # user should have access to the admin UI
    def admin_access_required
      access_denied unless admin?
    end
  
end
