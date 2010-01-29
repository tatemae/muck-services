cache({:format => 'xml', :details => @details, :limit => @limit, :order => @order, :id => + @entry.id}, :omit_feeds => @omit_feeds) do
  xml.instruct!
  xml.recommendations(:document_id => @entry.id, :uri => @entry.permalink, :title => t("muck.services.gm_title"),
          :more_prompt => t("muck.services.gm_more_prompt"), :direct_link_text => t("muck.services.direct_link")) do
    @recommendations.each do |recommendation|
      xml.recommendation do
        xml.title recommendation["title"]
        xml.collection recommendation["collection"]
        xml.link @app + '/r?id=' + recommendation["recommendation_id"].to_s
        xml.relevance recommendation["relevance"]

        if @details == true
          xml.recommendation_id recommendation["recommendation_id"]
          xml.uri recommendation["permalink"]
          xml.direct_uri recommendation["direct_link"]
          xml.description recommendation["description"]
          xml.clicks recommendation["clicks"]
          xml.average_time_at_dest recommendation["avg_time_on_target"]
          xml.published_at recommendation["published_at"]
          xml.author recommendation["author"]
        end
      end
    end
  end
end
