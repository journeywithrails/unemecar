ActionController::Routing::Routes.draw do |map|
  map.resources :simple_events
  #~ map.resources :series
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "pages", :action => "index"
  
  map.connect 'director/:evid/setup/:action/:id', :controller => "director/setup"
  map.connect 'director/:evid/summary/:action/:id', :controller => "director/summary"
  map.connect 'director/:evid/email/:action/:id', :controller => "director/email"
  map.connect 'director/:evid/marketing/:action/:id', :controller => "director/marketing"
  map.connect 'director/:evid/payments/:action/:id', :controller => "director/payments"
  map.connect 'director/:evid/registration/:action/:id', :controller => "director/registration"
  map.connect 'director/:evid/analytics/:action/:id', :controller => "director/analytics"
  
  #~ map.connect 'director/:uid/series/:action',:controller => "director/series"
  map.connect 'director/:evid/series/:action', :controller => "director/series"
  
  #~ map.serieslist 'director/series',:controller => "director/series",:action => "index"
  
  map.signup 'signup', :controller => 'sessions', :action => 'signup'
  map.forgot_password 'forgot_password', :controller => 'sessions', :action => 'forgot_password'
  map.reset_password 'reset_password', :controller => 'sessions', :action => 'reset_password'
  map.change_password 'change_password', :controller => 'sessions', :action => 'change_password'
  map.calendar 'calendar', :controller => 'events', :action => 'calendar'
  map.art 'art', :controller => 'pages', :action => 'art'
  map.login 'login', :controller => 'sessions', :action => 'login'
  map.logout 'logout', :controller => 'sessions', :action => 'logout'
  map.profile 'profile', :controller => 'myracemenu', :action => 'profile'
  map.about 'about', :controller=>"pages", :action=>"about"
  map.contact 'contact', :controller=>"pages", :action=>"contact"
  map.advertise 'advertise', :controller=>"pages", :action=>"advertise"
  map.policy 'privacy_policy', :controller=>"pages", :action=>"privacy"
  map.browser 'browser', :controller=>"pages", :action=>"browser"
  map.terms 'terms', :controller=>"pages", :action=>"terms"
  map.rd_services 'rd_services', :controller=>"director/preview", :action=>"index"
  map.rd_resources 'rd_resources', :controller=>"director/preview", :action=>"resources"
  #specific events
  map.commonwealth 'commonwealth', :controller=>"event", :action=>"show_detailed", :id => 5261
  map.thurstonfunrun 'thurstonfunrun', :controller=>"event", :action=>"show_detailed", :id => 6894
  map.boston2010 'boston2010', :controller=>"event", :action=>"show_detailed", :id => 6974
  map.brewrun 'brewrun', :controller=>"event", :action=>"show_detailed", :id => 7094
  map.acs 'acs', :controller=>"event", :action=>"show_detailed", :id => 7098
  map.jarrod 'jarrod', :controller=>"myracemenu", :action=>"index", :racer => "500115"
  map.alex 'alex', :controller=>"event", :action=>"show_detailed", :id => 7140
  map.teamelizabeth 'teamelizabeth', :controller=>"event", :action=>"show_detailed", :id => 7260
  map.stridesfortimmy 'stridesfortimmy', :controller=>"event", :action=>"show_detailed", :id => 7255
  map.gracerace 'gracerace', :controller=>"event", :action=>"show_detailed", :id => 7269
  
  map.nerelay 'nerelay', :controller=>"event", :action=>"show_detailed", :id => 6425
  map.doggy5k 'doggy5k', :controller=>"event", :action=>"show_detailed", :id => 7322
  map.monster 'monster', :controller=>"event", :action=>"show_detailed", :id => 7319
  map.holiday5k 'holiday5k', :controller=>"event", :action=>"show_detailed", :id => 7321
  map.anrasmor 'anrasmor', :controller=>"event", :action=>"show_detailed", :id => 7337
  map.races 'races', :controller=>"event", :action=>"show_detailed", :id => 7385
  
  map.connect 'event/:id', :controller => 'event', :action => 'index'
  
  #Redirect.find(:all)
  
  Redirect.find(:all).each do |redirect|
    map.connect redirect.text, :controller => 'event', :action => 'redirect', :red => redirect.url
  end
  
  # map.auto_complete ':controller/:action', 
  #        :requirements => { :action => /auto_complete_for_\S+/ },
  #        :conditions => { :method => :get }
  #        
  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
  #custom redirects in the code
  #map.connect ':redirect_url', :controller => 'event', :action => 'redirect'
end
