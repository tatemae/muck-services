class Muck::TopicsController < ApplicationController
  unloadable
  
  before_filter :adjust_format_for_iphone
  before_filter :check_terms, :except => [:new]
  before_filter :build_tag_feeds, :only => [:show, :rss_discovery]
  before_filter :configure_feed_loading, :only => [:show, :rss_discovery]
  
  caches_page [:show, :rss_discovery, :photos, :videos]
  
  def show
    
    load_feeds
    load_combined_feeds
    
    respond_to do |format|
      format.html do
        @opml_path = topic_path(params[:id], :service_ids => params[:service_ids], :format => 'opml')
        render :template => 'topics/show'
      end
      format.opml { render :template => 'topics/show' }
      format.iphone { render :template => 'topics/show' }
    end
  end

  def rss_discovery
    render :template => 'aggregations/rss_discovery'
  end

  def photos
    @terms = CGI.unescape(params[:id])
    @page_title = @title = @terms.titleize
    @photo_feeds = Service.build_photo_feeds(@terms, current_user, params[:service_ids])
    @number_of_images = 36
    respond_to do |format|
      format.html do
        render :template => 'topics/photos'
      end
      format.iphone { render :template => 'topics/photos' }
    end
  end

  def videos
    @terms = CGI.unescape(params[:id])
    @page_title = @title = @terms.titleize
    @videos_feeds = Service.build_video_feeds(@terms, current_user, params[:service_ids])
    @number_of_videos = 36
    respond_to do |format|
      format.html do
        render :template => 'topics/videos'
      end
      format.iphone { render :template => 'topics/videos' }
    end
  end
  
  def new
    @page_title = I18n.t('muck.services.new_topic_title')
    @service_categories = ServiceCategory.sorted.find(:all, :include => [:tag_services])
    respond_to do |format|
      format.html { render :template => 'topics/new' }
    end
  end

  def create
    @terms = CGI.escape(params[:terms])
    respond_to do |format|
      format.html { redirect_to topic_path(@terms, :service_ids => params[:service_ids]) }
      format.opml { redirect_to topic_path(@terms, :service_ids => params[:service_ids], :format => 'opml') }
    end
  end
  
  protected
    
    def check_terms
      if params[:id].blank? && params[:terms].blank?
        flash[:error] = I18n.t('muck.services.no_terms_error')
        redirect_to new_topic_path
      end
    end
    
    def build_tag_feeds
      @terms = CGI.unescape(params[:id])
      @page_title = @title = @terms.titleize
    
      @photo_feeds = Service.build_photo_feeds(@terms, current_user, params[:service_ids])
      @video_feeds = Service.build_video_feeds(@terms, current_user, params[:service_ids])
      @bookmark_feeds = Service.build_bookmark_feeds(@terms, current_user, params[:service_ids])
      @music_feeds = Service.build_music_feeds(@terms, current_user, params[:service_ids])
      @news_feeds = Service.build_news_feeds(@terms, current_user, params[:service_ids])
      @blog_feeds = Service.build_blog_feeds(@terms, current_user, params[:service_ids])
      @search_feeds = Service.build_search_feeds(@terms, current_user, params[:service_ids])
      
      @general_feeds = Service.build_general_feeds(@terms, current_user, params[:service_ids])

      @discovered_feeds = Overlord::GoogleFeedRequest.find_feeds(@terms)

      @feeds = @photo_feeds + @video_feeds + @bookmark_feeds + @music_feeds + @news_feeds + @blog_feeds + @search_feeds + @general_feeds + @discovered_feeds
    
    end
    
    def load_feeds
      if @load_feeds_on_server
        @server_loaded_general_feeds = Overlord::GoogleFeedRequest.load_feeds(@general_feeds + @discovered_feeds, @number_of_items)
        @server_loaded_photo_feeds = Overlord::GoogleFeedRequest.load_feeds(@photo_feeds, @number_of_images)
        @server_loaded_video_feeds = Overlord::GoogleFeedRequest.load_feeds(@video_feeds, @number_of_videos)
        @server_loaded_bookmark_feeds = Overlord::GoogleFeedRequest.load_feeds(@bookmark_feeds, @number_of_items)
        @server_loaded_music_feeds = Overlord::GoogleFeedRequest.load_feeds(@music_feeds, @number_of_items)
        @server_loaded_news_feeds = Overlord::GoogleFeedRequest.load_feeds(@news_feeds, @number_of_items)
        @server_loaded_blog_feeds = Overlord::GoogleFeedRequest.load_feeds(@blog_feeds, @number_of_items)
        @server_loaded_search_feeds = Overlord::GoogleFeedRequest.load_feeds(@search_feeds, @number_of_items)
        if @show_combined
          @server_combined_general_feeds = Feed.combine_sort(@server_loaded_general_feeds)
          @server_combined_photo_feeds = Feed.combine_sort(@server_loaded_photo_feeds)
          @server_combined_video_feeds = Feed.combine_sort(@server_loaded_video_feeds)
          @server_combined_bookmark_feeds = Feed.combine_sort(@server_loaded_bookmark_feeds)
          @server_combined_music_feeds = Feed.combine_sort(@server_loaded_music_feeds)
          @server_combined_news_feeds = Feed.combine_sort(@server_loaded_news_feeds)
          @server_combined_blog_feeds = Feed.combine_sort(@server_loaded_blog_feeds)
          @server_combined_search_feeds = Feed.combine_sort(@server_loaded_search_feeds)
        end
      end
    end
    
    def load_combined_feeds
      return unless @load_feeds_on_server
      @server_loaded_feeds = []
      @server_loaded_feeds += @server_loaded_general_feeds if @server_loaded_general_feeds 
      @server_loaded_feeds += @server_loaded_news_feeds if @server_loaded_news_feeds 
      @server_loaded_feeds += @server_loaded_blog_feeds if @server_loaded_blog_feeds 
      @server_loaded_feeds += @server_loaded_search_feeds if @server_loaded_search_feeds 
      @server_loaded_feeds += @server_loaded_photo_feeds if @server_loaded_photo_feeds 
      @server_loaded_feeds += @server_loaded_video_feeds if @server_loaded_video_feeds 
      @server_loaded_feeds += @server_loaded_bookmark_feeds if @server_loaded_bookmark_feeds 
      @server_loaded_feeds += @server_loaded_music_feeds if @server_loaded_music_feeds
      
      @server_loaded_data_feeds = []
      @server_loaded_data_feeds += @server_loaded_general_feeds if @server_loaded_general_feeds 
      @server_loaded_data_feeds += @server_loaded_news_feeds if @server_loaded_news_feeds 
      @server_loaded_data_feeds += @server_loaded_blog_feeds if @server_loaded_blog_feeds 
      @server_loaded_data_feeds += @server_loaded_search_feeds if @server_loaded_search_feeds
      
      @server_loaded_extended_data_feeds = []
      @server_loaded_extended_data_feeds += @server_loaded_data_feeds if @server_loaded_data_feeds
      @server_loaded_extended_data_feeds += @server_loaded_bookmark_feeds if @server_loaded_bookmark_feeds
      
      if @show_combined
        @server_combined_feeds = Feed.combine_sort(@server_loaded_feeds)
        @server_combined_data_feeds = Feed.combine_sort(@server_loaded_data_feeds)
        @server_combined_extended_data_feeds = Feed.combine_sort(@server_loaded_extended_data_feeds)
      end
      
    end
    
    def configure_feed_loading
      @number_of_items = 6
      @number_of_images = 12
      @number_of_videos = 6
      
      @show_google_search = GlobalConfig.show_google_search
      @show_combined = GlobalConfig.combine_feeds_on_server
      @load_feeds_on_server = GlobalConfig.load_feeds_on_server
    end
    
end
