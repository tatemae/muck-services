module ActiveRecord
  module Acts #:nodoc:
    module MuckRecommendations # :nodoc:

      def self.included(base)
        base.extend(ClassMethods)
      end
  
      module ClassMethods

        # +has_muck_recommendations+ gives the class it is called on personalized recommendations
        def has_muck_recommendations
          has_many :personal_recommendations, :as => :personal_recommendable
          has_many :recommended_resources, :through => :personal_recommendations, :class_name => 'Entry'
        end

      end

    end
  end
end