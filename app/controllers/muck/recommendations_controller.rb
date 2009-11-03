class Muck::RecommendationsController < ApplicationController
  
  unloadable
    
  # GET /recommendations
  # GET /recommendations.xml
  def index

    @real_time == params[:rtr]
    
    @details = params[:details] == "true"

    @uri = params[:u] || request.env['HTTP_REFERER']
    if @uri.blank? || !allowed_uri(@uri)
      render :text => '<!-- permission denied -->'
      return
    end
    
    if params[:educommons]
      @uri = @uri[%r=http://.*?/.*?/[^/]+=] || @uri
      params[:title] = true
      params[:more_link] = true
    end

#    Entry.track_time_on_page(session, @uri)
    @entry = Entry.recommender_entry(@uri)
#    I18n.locale = @entry.language[0..1] if !@entry.nil?

    @limit = params[:limit] ? params[:limit].to_i : 5
    @limit = 25 if @limit > 25
    
    respond_to do |format|
      format.html do
        order = params[:order] || "mixed"
        if !@entry.id.nil?
          redirect_to resource_path(@entry) + "?limit=#{@limit}&order=#{order}&details=#{@details}"
        else
          @recommendations = @entry.ranked_recommendations(@limit, params[:order] || "mixed", @details)
          render :template => 'recommendations/index'
        end
      end
      format.xml  { 
        render(:template => @entry.id.nil? && @real_time == true ? '/recommendations/index_real_time.xml.builder' : '/recommendations/index.xml.builder', :layout => false)
      }
      format.pjs {
        @host = "http://#{URI.parse(@uri).host}"
        render(:template => @entry.id.nil? && @real_time == true ? 'recommendations/index_real_time.pjs.erb' : 'recommendations/index.pjs.erb', :layout => false)
      }
      format.rss {
        render(:template => 'recommendations/index.rss.builder', :layout => false)  
      }
    end
  end
  
  protected
  
  def allowed_uri(uri)
    return false if uri.blank?
    uri.match(/^(10\.|192\.168|172\.|127\.)/) == nil && uri.include?('localhost') == false
  end
  
end
