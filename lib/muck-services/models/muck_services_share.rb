# include MuckServices::Models::MuckServicesShare
module MuckServices
  module Models
    module MuckServicesShare

      extend ActiveSupport::Concern
      
      included do
        belongs_to :entry
      end
      
      def discover_attach_to
        self.entry
      end
      
    end
  end
end