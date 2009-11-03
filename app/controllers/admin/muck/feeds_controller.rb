class Admin::Muck::FeedsController < Admin::Muck::BaseController

  unloadable

  def index
    @feeds = Feed.find(:all, :order => (params[:order] || 'created_at') + (params[:asc] == 'false' ? ' DESC' : ' ASC') + ', title', :include => [:default_language]).paginate(:page => @page, :per_page => @per_page)
    respond_to do |format|
      format.html { render :template => 'admin/feeds/index' }
      format.xml  { render :xml => @feeds.to_xml }
    end
  end

  def update
    feed = Feed.find(params[:id])
    if params[:status] == 'approve'
      approve(feed)
      flash[:notice] = t('muck.services.feed_validated_message')
    elsif params[:status] == 'ban'
      ban(feed)
      flash[:notice] = t('muck.services.feed_banned_message')
    end
    respond_to do |format|
      format.html { redirect_to admin_feeds_path }
    end
  end

  protected
  
    def ban(feed)
      feed.entries.destroy_all
      feed.status = MuckServices::Status::BANNED
      feed.save!
    end

    def approve(feed)
      feed.status = MuckServices::Status::APPROVED
      feed.save!
    end
  
end
