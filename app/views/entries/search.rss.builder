headers["Content-Type"] = "application/rss+xml"
xml.instruct! :xml, :version=>"1.0"	
xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
  xml.channel do

    xml.title       'Folksemantic - Search Results for: ' + URI.unescape(@search)
    xml.link        url_for(request.env["REQUEST_URI"])
    xml.pubDate     CGI.rfc1123_date Time.now
    xml.description 'Folksemanic - Search Results for: ' + URI.unescape(@search)
	xml.generator 'Folksemantic'

    xml.image do
        xml.title 'Folksemantic'
        xml.url 'http://www.folksemantic.com/images/folksemantic/logo-folksemantic-sm.gif'
        xml.link 'http://www.folksemantic.com/'
        xml.description 'Search, recommend, collaborate, and remix open educational resources'
    end

    @base_uri = request.protocol + request.host_with_port + '/visits/'
    @results.each do |result|
      xml.item do
        xml.title       result.title
        uri = "#{@base_uri}#{result.id}"
        xml.link        uri
        xml.guid        uri
        xml.pubDate		result.published_at
        xml.description	truncate_words(result.description)
      end
    end

  end
end

