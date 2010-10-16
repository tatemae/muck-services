Rails.application.routes.draw do
  # admin
  namespace :admin do
    resources :feeds, :controller => 'muck/feeds'
    resources :oai_endpoints, :controller => 'muck/oai_endpoints'
  end

  match '/feed_list' => 'muck/feeds#selection_list'

  match 'resources/search' => 'muck/entries#search'
  match 'resources/search.:format' => 'muck/entries#search'
  match 'search/results.:format' => 'muck/entries#search'
  match 'resources/tags/*tags' => 'muck/entries#browse_by_tags'
  resources :resources, :controller => 'muck/entries'

  match 'r' => 'muck/entries#track_clicks'
  match 'collections' => 'muck/entries#collections'

  resources :visits, :controller => 'muck/visits'
  resources :feed_previews, :controller => 'muck/feed_previews' do
    collection do
      post :select_feeds
    end
  end
  
  resources :entries, :controller => 'muck/entries' do
    collection do
      get :search
    end
    # have to map into the muck/comments controller or rails can't find the comments
    resources :comments, :controller => 'muck/comments'
  end
  
  resources :oai_endpoints, :controller => 'muck/oai_endpoints' do
    resources :feeds
  end
    
  resources :feeds, :controller => 'muck/feeds' do
    collection do
      get :new_extended
      get :new_oai_rss
    end
    resources :entries
  end

  match 'recommendations/real_time.:format' => 'muck/recommendations#real_time'
  match 'recommendations/get_button' => 'muck/recommendations#get_button'
  match 'recommendations/greasemonkey.user.js' => 'muck/recommendations#greasemonkey_script'
  resources :recommendations, :controller => 'muck/recommendations'

  resources :identity_feeds, :controller => 'muck/identity_feeds'
  resources :aggregations, :controller => 'muck/aggregations' do
    collection do
      get :preview
    end
    member do
      get :rss_discovery
    end
  end
  
  resources :aggregation_feeds, :controller => 'muck/aggregation_feeds'

  resources :topics, :controller => 'muck/topics' do
    member do
      get :rss_discovery 
      get :photos
      get :videos
    end
  end
  
  #match 'topics/*terms' => 'muck/topics#show'

end