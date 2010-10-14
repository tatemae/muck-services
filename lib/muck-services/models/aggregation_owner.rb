# include MuckServices::Models::MuckAggregationOwner
module MuckServices
  module Models
    module MuckAggregationOwner
      # Adds identity aggregations to a given object.  The aggregations
      # attached to the object in this way are then assumed to be produced by the object.
      # For example, if a user writes a blog the blog could be associated with the user in this way.

      extend ActiveSupport::Concern
      
      included do        
        has_many :aggregations, :as => :ownable
      end
      
    end
  end
end