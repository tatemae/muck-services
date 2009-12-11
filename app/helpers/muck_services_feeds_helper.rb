module MuckServicesFeedsHelper

  def add_feed(parent = nil)
    render :partial => 'parts/add_feed', :locals => {:parent => parent}
  end

  def new_feed_path_with_parent(parent, options = {})
    if parent
      feeds_path(make_parent_params(parent).merge(options))
    else
      feeds_path(options)
    end
  end

  def feed_contributor_link(feed)
    if feed.contributor_id.nil?
      admin = Feed.find_by_login('admin')
      'unknown'
    else
      link_to feed.contributor.display_name, profile_path(feed.contributor)
    end
  end

  def sort_feeds_link(current_order, current_asc, new_order, admin = false)
    if admin == true
      admin_feeds_url(:order => new_order, :asc => (current_order == new_order && (current_asc == 'true' || current_asc == nil)) ? 'false' : 'true')
    else
      feeds_url(:order => new_order, :asc => (current_order == new_order && (current_asc == 'true' || current_asc == nil)) ? 'false' : 'true')
    end
  end

end
