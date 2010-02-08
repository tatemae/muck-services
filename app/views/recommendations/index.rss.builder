cache({:locale => Language.locale_id, :format => 'rss', :details => @details, :limit => @limit, :order => @order, :id => @entry.id, :omit_feeds => @omit_feeds}) do
  headers["Content-Type"] = "application/rss+xml"
  xml.instruct!

  xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/", "xmlns:oerr" => "http://www.folksemantic.com/oerr/elements/1.0/" do
    xml.channel do

      xml.title "Folksemantic recommendations for " + @entry.permalink
      xml.link url_for(request.env["REQUEST_URI"])
      xml.generator 'Folksemantic'

      @recommendations.each do |recommendation|
        xml.item do
          xml.title recommendation["title"]
          xml.link (@app +'/r?id=' + recommendation["recommendation_id"])
          xml.guid (@app +'/r?id=' + recommendation["recommendation_id"])
          xml.oerr :relevance, recommendation["relevance"]

          if @details == true
            xml.oerr :recommendation_id, recommendation["recommendation_id"]
            xml.oerr :uri, recommendation["permalink"]
            xml.oerr :direct_uri, recommendation["direct_link"]
            if recommendation["description"] != nil
              xml.description "type" => "html" do
                xml.text! recommendation["description"]
              end
            end
            xml.oerr :clicks, recommendation["clicks"]
            xml.oerr :average_time_at_dest, recommendation["avg_time_on_target"]
            xml.pubDate CGI.rfc1123_date recommendation["published_at"]
            xml.author recommendation["author"]
          end
        end
      end
    end
  end
end