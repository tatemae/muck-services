headers["Content-Type"] = "application/rdf+xml"
xml.instruct!

xml.RDF :RDF, "xmlns:RDF" => "http://www.w3.org/1999/02/22-rdf-syntax-ns#", "xmlns:result" => "http://www.folksemantic.com/rdf#" do

  xml.RDF :Description, "RDF:about"=>"http://www.folksemantic.com/about/search/rdf" do
    xml.result :name do
      xml.text! 'Results for ' + html_escape(request.env["REQUEST_URI"])
    end
  end

  @base_uri = request.protocol + request.host_with_port + '/visits/'
  @results.each do |result|
    uri = "#{@base_uri}#{result.id}"
    xml.RDF :Description, "RDF:about" => uri do
      xml.result :title do
        xml.text! result.title
      end
      xml.result :uri do
        xml.text! uri
      end
      xml.result :description do
        xml.text! result.description
      end
      xml.result :permalink do
        xml.text! result.permalink
      end
    end
  end

  xml.RDF :Seq, "RDF:about" => url_for(:only_path => false, :controller => 'entries') do
    @results.each do |result|
      xml.RDF :li, "RDF:resource" => "#{@base_uri}#{result.id}"
    end
  end
end