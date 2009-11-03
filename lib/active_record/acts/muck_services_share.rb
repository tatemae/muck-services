module ActiveRecord
  module Acts #:nodoc:
    module MuckServicesShare # :nodoc:

      def self.included(base)
        base.extend(ClassMethods)
      end
  
      module ClassMethods

        def acts_as_muck_services_share(options = {})
          belongs_to :entry
          include ActiveRecord::Acts::MuckServicesShare::InstanceMethods
          extend ActiveRecord::Acts::MuckServicesShare::SingletonMethods
        end
      end
      
      # class methods
      module SingletonMethods
      end

      module InstanceMethods

        def discover_attach_to
          self.entry
        end
        
      end
      
    end
  end
end