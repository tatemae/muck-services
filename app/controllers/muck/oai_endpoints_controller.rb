class Muck::OaiEndpointsController < ApplicationController

  unloadable

  # pass layout=popup to remove most of the chrome
  def show
    @oai_endpoint = OaiEndpoint.find(params[:id])
    respond_to do |format|
      format.html { render :template => 'oai_endpoints/show', :layout => params[:layout] || true  }
      format.json { render :json => @oai_endpoint.as_json }
    end
  end

  def new
    respond_to do |format|
      format.html { render :template => 'oai_endpoints/new', :layout => params[:layout] || true }
    end
  end
  
  def create
    @oai_endpoint = OaiEndpoint.new(params[:oai_endpoint])
    @oai_endpoint.contributor = current_user # record the user that submitted the oai_endpoint for auditing purposes
    @oai_endpoint.inform_admin # let an admin know that a global oai_endpoint was added.
    after_create_response(@oai_endpoint.save)
  end

  def edit
    @oai_endpoint = OaiEndpoint.find(params[:id])
    respond_to do |format|
      format.html { render :template => 'oai_endpoints/edit', :layout => 'popup' }
    end
  end
  
  def update
    @oai_endpoint = OaiEndpoint.find(params[:id])
    after_update_response(@oai_endpoint.update_attributes(params[:oai_endpoint]))
  end

  def destroy
    @oai_endpoint = OaiEndpoint.find(params[:id])
    @oai_endpoint.destroy
    after_destroy_response
  end
  
  protected
  
    def has_permission_to_add_oai_endpoint(user, parent)
      user == parent || parent.can_add_oai_endpoint?(user)
    end
    
    # Handles render and redirect after success or failure of the
    # create action.  Override to perform a different action
    def after_create_response(success)
      if success
        flash[:notice] = t('muck.services.oai_endpoint_successfully_created')
        respond_to do |format|
          format.html { redirect_to oai_endpoint_path(@oai_endpoint) }
          format.pjs { redirect_to oai_endpoint_path(@oai_endpoint, :layout => 'popup') }
          format.json { render :json => @oai_endpoint.as_json }
          format.xml  { head :created, :location => oai_endpoint_url(@oai_endpoint) }
        end
      else
        respond_to do |format|
          format.html { render :template => "oai_endpoints/new" }
          format.pjs { render :template => "oai_endpoints/new", :layout => false }
          format.json { render :json => @oai_endpoint.as_json }
          format.xml  { render :xml => @oai_endpoint.errors.to_xml }
        end
      end
    end
  
    # Handles render and redirect after success or failure of the
    # update action.  Override to perform a different action
    def after_update_response(success)
      respond_to do |format|
        if success
          flash[:notice] = t('muck.services.oai_endpoint_successfully_updated')
          format.html { redirect_to oai_endpoint_path(@oai_endpoint) }
          format.xml  { head :ok }
        else
          format.html { render :template => "oai_endpoints/edit" }
          format.xml  { render :xml => @oai_endpoint.errors.to_xml }
        end
      end
    end
    
    # Handles render and redirect after the delete action.
    # Override to perform a different action
    def after_destroy_response
      respond_to do |format|
        format.html { redirect_to oai_endpoints_path }
        format.xml  { head :ok }
      end
    end
    
end
