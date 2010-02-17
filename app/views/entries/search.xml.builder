headers["Content-Type"] = "application/xml"
xml.instruct!

xml.results(:search => URI.unescape(params[:terms]), :hits => @hit_count, :offset => @offset, :limit => @per_page)do
  @base_uri = request.protocol + request.host_with_port + '/visits/'
  @results.each do |result|
    xml.result(:published_at => result.published_at, :relevance => result.solr_score) do
      xml.id result.id
      xml.title result.title
      xml.description truncate_words(result.description)
      xml.uri "#{@base_uri}#{result.id}"
      xml.permalink result.permalink
      xml.direct_link result.direct_link
      xml.collection result.collection
    end
  end
end
