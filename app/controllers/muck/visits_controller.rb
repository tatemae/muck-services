class Muck::VisitsController < ApplicationController
  
  unloadable

  before_filter :store_location

  def show
    @entry = Entry.find(params[:id])
    @page_title = @entry.title
    @resource_uri = @entry.resource_uri
    @share = Share.new(:title => @entry.title, :uri => @resource_uri, :entry_id => @entry.id) if MuckServices.configuration.enable_services_shares
    @recommendations = @entry.related_entries.top

    if MuckServices.configuration.enable_services_comments
      # Show the activities related to this entry
      @activities = @entry.activities.by_oldest.is_public.find(:all, :include => ['comments'])
      @comment_count = @activities.length + @activities.inject(0) {|n,activity| activity.comments.length + n }
    end
    
    respond_to do |format|
      format.html { render :template => 'visits/show', :layout => 'frame' }
      format.pjs { render :template => 'visits/show', :layout => false }
      format.json { render :json => @entry.as_json }
    end
  end

end
