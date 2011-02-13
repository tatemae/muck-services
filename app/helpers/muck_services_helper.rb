module MuckServicesHelper

  def tag_list(tags)
    atags = tags.split(',')
    # get rid of the first two items
    atags.shift 
    atags.shift
    atags.each_slice(2){|tag,frequency| yield tag,frequency }
  end
  
  def tag_cloud(tag_list, classes)
    atags = tag_list.split(',')
    min = atags.shift.to_f
    max = atags.shift.to_f
    range = max - min
    scale = range == 0 ? 1 : classes.length.to_f / range.to_f
    atags.each_slice(2){|tag,index| yield tag, classes[((index.to_i - min)*scale).to_i]}
  end
  
  def tag_link(tag, css_class, grain_size)
     link_to h(tag), "/resources/tags/#{tag}?grain_size=#{grain_size}", :class => css_class
  end
  
  def filtered_tag_link(tag, filter, css_class, grain_size)
     link_to h(tag), "/resources/tags/#{filter.join('/')}/#{tag}?grain_size=#{grain_size}", :class => css_class
  end
  
  def results_status
    if @tag_filter.nil?
      if (@grain_size == 'course')
        t('muck.services.course_search_results', 
        :first => @offset+1, 
        :last => (@offset + @per_page) < @hit_count ? (@offset + @per_page) : @hit_count,
        :total => @hit_count,
        :filter => @tag_filter,
        :terms => URI.unescape(@term_list)).html_safe
      else
        t('muck.services.resource_search_results', 
        :first => @offset+1, 
        :last => (@offset + @per_page) < @hit_count ? (@offset + @per_page) : @hit_count,
        :total => @hit_count,
        :filter => @tag_filter,
        :terms => URI.unescape(@term_list)).html_safe
      end
    else
      if (@grain_size == 'course')
        t('muck.services.course_tag_results', 
        :first => @offset+1, 
        :last => (@offset + @per_page) < @hit_count ? (@offset + @per_page) : @hit_count,
        :total => @hit_count,
        :filter => @tag_filter,
        :terms => @tag_filter.split('/').join('</b>, <b>')).html_safe
      else
        t('muck.services.resource_tag_results', 
        :first => @offset+1, 
        :last => (@offset + @per_page) < @hit_count ? (@offset + @per_page) : @hit_count,
        :total => @hit_count,
        :filter => @tag_filter,
        :terms => @tag_filter.split('/').join('</b>, <b>')).html_safe
      end
    end
  end
  
  def feed_query_uri(feed)
    "/search/results?terms=feed_id:" + feed.id.to_s + "&locale=en"
  end
  
  def already_shared_entry?(user, entry)
    user.shares.find(:all, :conditions => ['entry_id = ?', entry.id]).length > 0
  end
  
  def encode_feed_links(feeds)
    @feeds.collect { |feed| "&n_32=url%3D#{CGI.escape(feed.uri)}" }.join('')
  end
  
end
