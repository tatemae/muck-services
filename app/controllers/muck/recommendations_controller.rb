class Muck::RecommendationsController < ApplicationController

  unloadable
    
  def index
    # if a uri isn't specified in params, we assume that they are requesting from the page doing the requesting
    @uri = params[:u] || request.env['HTTP_REFERER']
    if @uri.blank? || !allowed_uri(@uri)
      render :text => '<!-- permission denied -->'
      return
    end

    # we trim eduCommons urls back to the course so all pages in the course get the same recommendations
    if params[:educommons]
      @uri = @uri[%r=http://.*?/.*?/[^/]+=] || @uri
      params[:title] = true
      params[:more_link] = true
    end

    @details = (params[:details] == 'true')
    @limit = params[:limit] ? params[:limit].to_i : 5
    @limit = 25 if @limit > 25
    @omit_feeds = params[:omit_feeds]
    @order = params[:order] == 'relevance' ? 'relevance desc' : (params[:order] || "rank asc, relevance desc")

    Entry.track_time_on_page(session, @uri)
    @entry = Entry.recommender_entry(@uri)
    @recommendations = @entry.related_entries.top(@details, @limit, @omit_feeds, @order)
    @app = request.protocol + request.host_with_port

    respond_to do |format|
      format.html do
        if !@entry.id.nil?
          redirect_to resource_path(@entry) + "?limit=#{@limit}&order=#{@order}&details=#{@details}"
        else
          render(:text => t('muck.services.url_not_in_index', :uri => params[:uri]), :layout => true)
        end
      end
      format.xml  { render('recommendations/index.xml.builder', :layout => false) }
      format.pjs { render('recommendations/index.pjs.erb', :layout => false) }
      format.rss { render('recommendations/index.rss.builder', :layout => false) }
      format.js { render('recommendations/index.js.erb', :layout => false) }
    end
  end

  def get_button
    @uri = params[:u]
    render 'recommendations/get_button', :layout => false
  end

  def greasemonkey_script
    render :template => '/recommendations/greasemonkey.user.js.erb', :layout => false
  end

  def real_time
    respond_to do |format|
      format.html do
        @uri = params[:u]
        @cache_key = "recommendations/real_time?u=#{CGI.escape(@uri)}"
        if !fragment_exist?(@cache_key)
          @recommendations = Entry.real_time_recommendations(@uri, I18n.locale.to_s, 5)
        end
        render 'recommendations/real_time', :layout => false
      end
    end
  end
  
  protected
  
  def allowed_uri(uri)
    return false if uri.blank?
    uri.match(/^(10\.|192\.168|172\.|127\.)/) == nil && uri.include?('localhost') == false
  end
  
end
