require 'muck-services'
require 'rails'

module MuckServices
  class Engine < ::Rails::Engine
    
    def muck_name
      'muck-services'
    end
    
    initializer 'muck-services.helpers' do |app|
      ActiveSupport.on_load(:action_view) do
        include MuckServicesHelper
        
        include MuckServicesFeedsHelper
        include MuckServicesServiceHelper
        include MuckServicesAggregationsHelper
      end
    end
    
    initializer 'muck-services.i18n' do |app|
      ActiveSupport.on_load(:i18n) do
        I18n.load_path += Dir[ File.join(File.dirname(__FILE__), '..', '..', 'config', 'locales', '*.{rb,yml}') ]
      end
    end
        
    initializer 'muck-services.form' do
      MuckEngine::FormBuilder.send :include, MuckServicesCustomFormBuilder
    end
    
  end
end
