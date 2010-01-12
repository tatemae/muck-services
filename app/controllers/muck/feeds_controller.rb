class Muck::FeedsController < ApplicationController

  unloadable
  
  before_filter :login_required, :except => ['index', 'show']
  before_filter :get_owner, :except => ['index', 'show']
  
  def index
    @feeds = Feed.find(:all, :conditions => 'status >= 0', :order => (params[:order] || 'title') + (params[:asc] == 'false' ? ' DESC' : ' ASC') + ', title', :include => [:default_language]).paginate(:page => @page, :per_page => @per_page)
    respond_to do |format|
      format.html { render :template => 'feeds/index' }
      format.xml  { render :xml => @feeds.to_xml }
    end
  end

  # pass layout=popup to remove most of the chrome
  def show
    @feed = Feed.find(params[:id])
    @entries = @feed.entries.paginate(:page => @page, :per_page => @per_page)
    respond_to do |format|
      format.html { render :template => 'feeds/show', :layout => get_layout_by_params  }
      format.pjs do
        render :update do |page|
          page.replace_html('feed-container', :partial => 'feeds/feed', :object => @feed)
        end
      end
      format.json { render :json => @feed.as_json }
    end
  end

  def new
    setup_new
    respond_to do |format|
      format.html { render :template => 'feeds/new', :layout => get_layout_by_params }
    end
  end

  def new_oai_rss
    setup_new
    respond_to do |format|
      format.html { render :template => 'feeds/new_oai_rss', :layout => get_layout_by_params }
    end
  end
  
  def new_extended
    respond_to do |format|
      format.html { render :template => 'feeds/new_extended', :layout => get_layout_by_params }
    end
  end

  def create

    Feed.discover_feeds(params[:feed][:uri]) unless params[:feed][:uri].blank?
    
    @feed = Feed.new(params[:feed])
    @feed.contributor = current_user # record the user that submitted the feed for auditing purposes
    @feed.harvested_from_display_uri = @feed.display_uri
    
    # setup the feed to be harvested
    @feed.entries_count = 0
    @feed.last_requested_at = 4.weeks.ago
    @feed.last_harvested_at = 4.weeks.ago

    @feed.inform_admin # let an admin know that a global feed was added.

    # associate the parent if present
    @parent.feeds << @feed if @parent
    
    after_create_response(@feed.save)
  end

  def edit
    @feed = Feed.find(params[:id])
    respond_to do |format|
      format.html { render :template => 'feeds/edit', :layout => get_layout_by_params }
    end
  end
  
  def update
    @feed = Feed.find(params[:id])
    after_update_response(@feed.update_attributes(params[:feed]))
  end

  def destroy
    @feed = Feed.find(params[:id])
    @feed.destroy
    after_destroy_response
  end
  
  protected

    def get_owner
      @parent = get_parent
      unless has_permission_to_add_feed(current_user, @parent)
        permission_denied
      end
    end
  
    def has_permission_to_add_feed(user, parent)
      return false if user.blank?
      return true if user.admin?
      return true if user.can_add_feeds?
      return false if parent.blank?
      user == parent || parent.can_add_feed?(user)
    end
    
    # Handles render and redirect after success or failure of the
    # create action.  Override to perform a different action
    # fail_template determines which 'new' is rendered in the event that
    # the create is not successful.
    def after_create_response(success)
      if success
        flash[:notice] = t('muck.services.feed_successfully_created')
        respond_to do |format|
          format.html { redirect_to feed_path(@feed, :layout => get_layout_by_params) }
          format.pjs { redirect_to feed_path(@feed, :layout => 'popup') }
          format.json { render :json => @feed.as_json }
          format.xml  { head :created, :location => feed_url(@feed) }
        end
      else
        fail_template = params[:new_template] || 'feeds/new'
        respond_to do |format|
          format.html { render :template => fail_template, :layout => get_layout_by_params }
          format.pjs { render :template => fail_template, :layout => false }
          format.json { render :json => @feed.as_json }
          format.xml  { render :xml => @feed.errors.to_xml }
        end
      end
    end
  
    # Handles render and redirect after success or failure of the
    # update action.  Override to perform a different action
    def after_update_response(success)
      respond_to do |format|
        if success
          flash[:notice] = t('muck.services.feed_successfully_updated')
          format.html { redirect_to feed_path(@feed, :layout => get_layout_by_params) }
          format.xml  { head :ok }
        else
          format.html { render :template => "feeds/edit" }
          format.xml  { render :xml => @feed.errors.to_xml }
        end
      end
    end
    
    # Handles render and redirect after the delete action.
    # Override to perform a different action
    def after_destroy_response
      respond_to do |format|
        format.html { redirect_to feeds_path }
        format.xml  { head :ok }
      end
    end
    
    def setup_new
      @page_title = t('muck.services.add_new_feed_title')
      @feed = Feed.new
      @feed.default_language = Language.find_by_locale('en')
      @feed.service_id = MuckServices::Services::RSS
      @oai_endpoint = OaiEndpoint.new
      @oai_endpoint.default_language = @feed.default_language
    end
    
    def get_layout_by_params
      if params[:layout].blank? || params[:layout] == 'true'
        true
      else
        params[:layout] 
      end
    end
    
end
