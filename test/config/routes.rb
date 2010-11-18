RailsTest::Application.routes.draw do
  root :to => "default#index"
  
  resources :users, :controller => 'muck/users' do
    # have to map into the muck/identity_feeds controller or rails can't find the identity_feeds
    resources :identity_feeds, :controller => 'muck/identity_feeds'
    resources :aggregations, :controller => 'muck/aggregations'
    resources :feeds, :controller => 'muck/feeds'
  end
  
  match ':controller(/:action(/:id(.:format)))'
end