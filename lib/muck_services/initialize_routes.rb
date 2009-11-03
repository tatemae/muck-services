class ActionController::Routing::RouteSet
  def load_routes_with_muck_services!
    muck_services_routes = File.join(File.dirname(__FILE__), *%w[.. .. config muck_services_routes.rb])
    add_configuration_file(muck_services_routes) unless configuration_files.include? muck_services_routes
    load_routes_without_muck_services!
  end
  alias_method_chain :load_routes!, :muck_services
end