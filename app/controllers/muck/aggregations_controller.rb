class Muck::AggregationsController < ApplicationController

  unloadable
  
  #before_filter :adjust_format_for_iphone
  
  require 'cgi'
  
  before_filter :login_required, :except => [:index, :show, :preview, :rss_discovery]
  before_filter :get_owner, :only => [:index, :preview, :new, :create]
  before_filter :check_user_permissions, :only => [:create]
  before_filter :get_aggregation, :only => [:destroy, :edit, :update, :show, :rss_discovery]
  before_filter :has_aggregation_permission?, :only => [:destroy, :edit, :update]
  before_filter :setup_feed_display_variables, :only => [:preview, :update]
  def index
    if @parent
      @aggregations = @parent.aggregations.by_title
    else
      @aggregations = Aggregation.newest
    end
    render(:template => 'aggregations/index')
    # respond_to do |format|
    #   format.html { render(:template => 'aggregations/index') }
    #   format.iphone { render(:template => 'aggregations/index') }
    # end
  end
  
  def rss_discovery
    @feeds = @aggregation.feeds
    render :template => 'aggregations/rss_discovery'
  end
  
  def show
    @page_title = @aggregation.title
    
    @photo_feeds = @aggregation.photo_feeds
    @video_feeds = @aggregation.video_feeds
    @bookmark_feeds = @aggregation.bookmark_feeds
    @music_feeds = @aggregation.music_feeds
    @general_feeds = @aggregation.general_feeds
    
    if GlobalConfig.render_feeds_client_side
      
    elsif GlobalConfig.render_feeds_server_side
      @feeds = @aggregation.feeds
    else
      @entries = @aggregation.feeds.entries.paginate(:page => @page, :per_page => @per_page)
    end
    respond_to do |format|
      format.html { render(:template => 'aggregations/show') }
      format.opml { render(:layout => false) }
      format.rss {}
    end
  end
  
  def preview
    if params[:terms].blank?
      flash[:error] = I18n.t('muck.services.no_terms_error')
      redirect_to new_polymorphic_url([@parent, :aggregation])
    else
      terms = params[:terms]
      terms = terms.join(' ') if terms.is_a?(Array)
      
      #@feeds = Service.build_tag_feeds(terms, current_user, params[:service_ids])
      
      @photo_feeds = Service.build_photo_feeds(terms, current_user)
      @video_feeds = Service.build_video_feeds(terms, current_user)
      @bookmark_feeds = Service.build_bookmark_feeds(terms, current_user)
      @music_feeds = Service.build_music_feeds(terms, current_user)
      @general_feeds = Service.build_general_feeds(terms, current_user)

      @discovered_feeds = Overlord::GoogleFeedRequest.find_feeds(terms)
      @title = terms.titleize
      @terms = terms
      
      @aggregation = Aggregation.new(:title => @title, :terms => @terms)

      respond_to do |format|
        format.html { render :template => 'aggregations/preview' }
      end
    end
  end

  def new
    @page_title = I18n.t('muck.services.new_aggregation')
    @service_categories = ServiceCategory.sorted.find(:all, :include => [:tag_services])
    respond_to do |format|
      format.html { render :template => 'aggregations/new' }
    end
  end
  
  def create
    @aggregation = Aggregation.create(params[:aggregation])
    @parent.aggregations << @aggregation if @parent # associate the parent if present
    
    # build a list of feeds and associate them with the aggregation
    @aggregation.add_feeds(current_user, params[:service_ids])
    @aggregation.add_feeds_by_uri(current_user, params[:uris])

    respond_to do |format|
      flash[:notice] = I18n.t('muck.services.add_feeds_to_aggregation', :title => @aggregation.title)
      format.html { redirect_to(edit_aggregation_path(@aggregation)) }
      format.xml  { render :xml => @aggregation, :status => :created, :location => @aggregation }
    end

  rescue ActiveRecord::RecordInvalid => ex
    respond_to do |format|
      format.html { render :action => "aggregations/new" }
      format.xml  { render :xml => @aggregation.errors }
    end
  end
  
  def edit
    setup_edit
    respond_to do |format|
      format.html { render :template => 'aggregations/edit' }
    end
  end

  def update
    if params[:aggregation]
      @aggregation.update_attributes!(params[:aggregation])
      flash[:notice] = I18n.t('muck.services.aggregation_updated')
    end
    @feeds = []
    if params[:uri]
      @feeds = Feed.feeds_from_uri(params[:uri], current_user)
      @aggregation.safe_add_feeds(@feeds)
    elsif params[:service_ids]
      @aggregation.terms = @aggregation.terms + ",#{params[:terms]}"
      @aggregation.save!
      @feeds = @aggregation.add_feeds(current_user, params[:service_ids])
    end
    
    message = I18n.t('muck.services.no_feeds_found') if @feeds.blank?
    
    respond_to do |format|
      format.html { redirect_to edit_polymorphic_url([@aggregation.ownable, @aggregation]) }
      format.xml  { head :ok }
      format.json do
        render :json => { :aggregation => @aggregation,
                          :feeds => @feeds,
                          :message => message,
                          :success => true,
                          :html => get_google_feed_html }.as_json
      end
    end
  rescue ActiveRecord::RecordInvalid => ex
    respond_to do |format|
      format.html do
        setup_edit
        render :template => "aggregations/edit"
      end
      format.json { render :json => { :aggregation => @aggregation, 
                                      :feeds => @feeds, 
                                      :message => ex.to_s, 
                                      :success => false, 
                                      :html => '' }.as_json }
      format.xml  { render :xml => @aggregation.errors }
    end
  end

  def destroy
    @aggregation = Aggregation.find(params[:id])
    @aggregation.destroy
    respond_to do |format|
      flash[:notice] = I18n.t('muck.services.aggregation_deleted', :title => @aggregation.title)
      format.html { redirect_to polymorphic_url([@aggregation.ownable, :aggregations]) }
      format.xml  { head :ok }
    end
  end

  protected
    
    def setup_edit
      @feeds = @aggregation.all_feeds
      setup_feed_display_variables
      @service_categories = ServiceCategory.sorted.find(:all, :include => [:tag_services])
      @page_title = I18n.t('muck.services.edit_aggregation_title', :title => @aggregation.title)
    end
    
    def get_owner
      @parent = get_parent
    end
    
    def check_user_permissions
      unless has_permission?
        permission_denied
      end
    end
    
    def get_aggregation
      @aggregation = Aggregation.find(params[:id])
    end
    
    def has_aggregation_permission?
      if !@aggregation.can_edit?(current_user)
        message = I18n.t('muck.services.cant_modify_aggregation')
        respond_to do |format|
          format.html do
            flash[:notice] = message
            redirect_back_or_default current_user
          end
          format.js { render(:update) {|page| page.alert message} }
        end
      end
    end
    
    def has_permission?
      if @parent.blank?
        admin?
      else
        @parent.can_edit?(current_user)
      end
    end
  
    def setup_feed_display_variables
      @show_controls = show_controls?
      @number_of_items = 4
      @number_of_images = 6
      @number_of_videos = 6
    end
    
    # determines whether or not to show admin controls (ie save aggregation)
    def show_controls?
      logged_in?
    end
    
    def get_google_feed_html
      render_as_html do
        render_to_string(:partial => 'aggregations/feeds')
      end
    end
    
end
