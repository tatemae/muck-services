xml.instruct! :xml, :version => "1.0", :encoding => "UTF-8"
xml.opml :version => "1.0" do
  xml.head do
    xml.title(t('muck.services.opml_generated', :terms => @title))
  end
  xml.body do
    xml.outline(:title => t('muck.services.opml_feeds_for', :terms => @title), :text => t('muck.services.opml_feeds_for', :terms => @title)) do
      @feeds.each do |feed|
        xml.outline(:text => feed.title,
                    :title => feed.title,
                    :type => 'rss', 
                    :xmlUrl => feed.uri,
                    :htmlUrl => feed.display_uri)
      end
      
    end
  end
end