module MuckServicesServiceHelper
  
  # Render a summary of all services for the given parent.  The parent should 'acts_as_muck_feed_owner' 
  def services_summary(parent)
    identity_feeds = parent.identity_feeds.find(:all, :include => [{:feed => :service}])
    render :partial => 'services/summary', :locals => { :identity_feeds => identity_feeds }
  end

  # Render personal recommendations
  def personal_recommendations(user, limit = 5)
    render :partial => 'services/personal_recommendations', :locals => { :recommendations => user.personal_recommendations.limit(5) }
  end
  
  # Render a view with all services in categories.
  # service_categories: Results from a query to service_categories.  For performance try something like this:
  #                     ServiceCategory.sorted.find(:all, :include => [:identity_services])
  # title: Optional title.  Default is 'Available Services' - from I18n.t('muck.services.available_services')
  # css: Optional css to be added to the div that surrounds the categories
  def available_service_categories(service_categories, title = nil, css = '')
    render :partial => 'identity_feeds/available_service_categories', :locals => { :service_categories => service_categories, :css => css, :title => title }
  end
  
  # Render a view with the user's registered services.
  # identity_feeds: Results from a query to service_categories.  For performance try something like this:
  #                 @user.identity_feeds.find(:all, :include => [{:feed => :service}])
  # title: Optional title.  Default is 'My Services' - from I18n.t('muck.services.my_services')
  # css: Optional css to be added to the div that surrounds the categories
  def services_for_user(identity_feeds, title = nil, css = '')
    render :partial => 'identity_feeds/services_for_user', :locals => { :identity_feeds => identity_feeds, :css => css, :title => title, :edit => false }
  end
  
  # Render an edit view with the user's registered services.
  # identity_feeds: Results from a query to service_categories.  For performance try something like this:
  #                 @user.identity_feeds.find(:all, :include => [{:feed => :service}])
  # title: Optional title.  Default is 'My Services' - from I18n.t('muck.services.my_services')
  # css: Optional css to be added to the div that surrounds the categories
  def services_for_user_edit(identity_feeds, title = nil, css = '')
    render :partial => 'identity_feeds/services_for_user', :locals => { :identity_feeds => identity_feeds, :css => css, :title => title, :edit => true }
  end

  # Renders name and icon for the service
  def service_title(service)
    %Q{<div class="identity-service-title" #{service_icon_background(service)}>#{service_prompt(service)}</div>}
  end
    
  # By default renders Service username e.g. Flickr username
  # If the service has a 'prompt' set it will look for a value in the localization
  # files.  For example, setting service.prompt to 'blog_url' will cause this method
  # to look for a translation at muck.services.blog_url and will pass the name of the service
  # using 'service' so your translation might look like:
  # muck.services.blog_url: "Blog Url" or
  # muck.services.facebook_prompt: "{{service}} Feeds"
  def service_prompt(service)
    if @service.prompt.blank?
      I18n.t('muck.services.service_username', :service => @service.name)
    else
      I18n.t("muck.services.#{@service.prompt}", :service => @service.name)
    end
  end
  
  # Renders a link for a new user service with class 'lightbox' or optional css set on the link.
  def service_lightbox(parent, service, link_css = 'lightbox', wrapper = 'li')
    path = new_polymorphic_url([parent, :identity_feed], :service_id => service.to_param)
    service_link(path, service, link_css, wrapper, nil, nil, "#{service.name.parameterize}-link")
  end

  # Renders a link for editing a user feed with class 'lightbox' or optional css set on the link.
  def service_lightbox_edit(parent, identity_feed, link_css = 'lightbox', wrapper = nil)
    path = edit_polymorphic_url([parent, identity_feed])
    link_text = identity_feed.feed.title unless identity_feed.feed.title.blank?
    service_link(path, identity_feed.feed.service, link_css, wrapper, link_text)
  end
  
  def service_external_link(identity_feed, link_css = nil, wrapper = nil)
    path = identity_feed.feed.display_uri || identity_feed.feed.uri
    link_text = identity_feed.feed.title unless identity_feed.feed.title.blank?
    service_link(path, identity_feed.feed.service, link_css, wrapper, link_text, 'blank')
  end
  
  # Renders a delete button for an identity_feed
  def service_delete(identity_feed, button_type = :button, button_text = t("muck.general.delete"))
    render :partial => 'shared/delete', :locals => { :delete_object => identity_feed, 
                                                     :button_type => button_type,
                                                     :button_text => button_text,
                                                     :form_class => 'identity-feed-delete',
                                                     :delete_path => identity_feed_path(identity_feed, :format => 'js') }
  end
  
  # Renders a service link optionally wrapping it in the specified element
  def service_link(path, service, link_css, wrapper, link_text = nil, target = nil, id = nil)
    link = %Q{<a #{'id=' + id if id} href="#{path}" #{service_icon_background(service)} #{'target=' + target if target} class="service-link #{link_css}">#{link_text || service.name}</a>}
    if wrapper
      content_tag wrapper, link, :class => 'identity-service' 
    else
      link
    end
  end
  
  def url_by_identity_feed(owner, identity_feed, service)
    if identity_feed
      polymorphic_url([owner, identity_feed], :service_id => service.to_param)
    else
      polymorphic_url([owner, :identity_feeds], :service_id => service.to_param)
    end
  end
  
end