ActionController::Routing::Routes.draw do |map|
  # admin
  map.namespace :admin do |a|
    a.resources :feeds, :controller => 'muck/feeds'
    a.resources :oai_endpoints, :controller => 'muck/oai_endpoints'
  end

  map.connect '/feed_list', :controller => 'muck/feeds', :action => 'selection_list'

  map.connect 'resources/search', :controller => 'muck/entries', :action => 'search'
  map.connect 'resources/tags/*tags', :controller => 'muck/entries', :action => 'browse_by_tags'
  map.resources :resources, :controller => 'muck/entries'

  map.connect 'r', :controller => 'muck/entries', :action => 'track_clicks'
  map.connect 'collections', :controller => 'muck/entries', :action => 'collections'

  map.resources :visits, :controller => 'muck/visits'
  map.resources :feed_previews, :controller => 'muck/feed_previews', :collection => { :select_feeds => :post }
  
  map.resources :entries, :controller => 'muck/entries', :collection => { :search => :get } do |entries|
    # have to map into the muck/comments controller or rails can't find the comments
    entries.resources :comments, :controller => 'muck/comments'
  end
  
  map.resources :oai_endpoints, :controller => 'muck/oai_endpoints', :has_many => :feeds
    
  map.resources :feeds, :controller => 'muck/feeds', :collection => { :new_extended => :get, :new_oai_rss => :get }, :has_many => :entries

  map.connect 'recommendations/real_time', :controller => 'muck/recommendations', :action => 'real_time'
  map.connect 'recommendations/get_button', :controller => 'muck/recommendations', :action => 'get_button'
  map.resources :recommendations, :controller => 'muck/recommendations'

  map.resources :identity_feeds, :controller => 'muck/identity_feeds'
  map.resources :aggregations, :controller => 'muck/aggregations', :collection => { :preview => :get }, :member => { :rss_discovery => :get }
  map.resources :aggregation_feeds, :controller => 'muck/aggregation_feeds'

  map.resources :topics, :controller => 'muck/topics', :member => { :rss_discovery => :get, :photos => :get, :videos => :get }
  #map.connect 'topics/*terms', :controller => 'muck/topics', :action => 'show'

end