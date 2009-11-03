class Admin::Muck::OaiEndpointsController < Admin::Muck::BaseController

  unloadable
  
  def index
    @oai_endpoints = OaiEndpoint.by_newest.paginate(:page => @page, :per_page => @per_page)
    respond_to do |format|
      format.html { render :template => 'admin/oai_endpoints/index' }
      format.xml  { render :xml => @oai_endpoints.to_xml }
    end
  end

end
