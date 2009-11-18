ActiveSupport::Dependencies.load_once_paths << lib_path

if config.respond_to?(:gems)
  config.gem "acts-as-taggable-on"
else
  begin
    require 'acts-as-taggable-on'
  rescue LoadError
    begin
      gem 'acts-as-taggable-on'
    rescue Gem::LoadError
      puts "Please install the acts-as-taggable-on gem"
    end
  end
end

require 'muck_services'
require 'muck_services/initialize_routes'
