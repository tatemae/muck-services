module MuckServicesAggregationsHelper
  
  def data_sources(service_categories)
    render :partial => 'aggregations/data_sources', :locals => { :service_categories => service_categories }
  end
  
  def data_source_checked?(data_source)
    true
  end
  
  def feed_preview(feeds, discovered_feeds, related_title = nil, number_of_items = 5, number_of_images = 20, content_id = nil)
    render :partial => 'topics/feed_preview', :locals => {:feeds => feeds,
                                                         :related_title => related_title,
                                                         :discovered_feeds => discovered_feeds,
                                                         :number_of_items => number_of_items,
                                                         :number_of_images => number_of_images,
                                                         :content_id => content_id }
  end
  
  def aggregation_parent_name(parent)
    if @parent
      "#{@parent.to_s.underscore}"
    else
      'Aggregation'
    end
  end
  
  def topics_form
    render :partial => 'topics/form'
  end
  
end