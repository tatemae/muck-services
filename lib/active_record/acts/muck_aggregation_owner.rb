module ActiveRecord
  module Acts #:nodoc:
    module MuckAggregationOwner # :nodoc:

      def self.included(base)
        base.extend(ClassMethods)
      end
  
      module ClassMethods
        
        # +acts_as_muck_aggregation_owner+ adds identity aggregations to a given object.  The aggregations
        # attached to the object in this way are then assumed to be produced by the object.
        # For example, if a user writes a blog the blog could be associated with the user in this way.
        def acts_as_muck_aggregation_owner
          has_many :aggregations, :as => :ownable
          include ActiveRecord::Acts::MuckAggregationOwner::InstanceMethods
          extend ActiveRecord::Acts::MuckAggregationOwner::SingletonMethods
        end
      end

      # class methods
      module SingletonMethods
      end
      
      module InstanceMethods
      end
      
    end
  end
end