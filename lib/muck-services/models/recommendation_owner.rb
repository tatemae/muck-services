# include MuckServices::Models::MuckRecommendationOwner
module MuckServices
  module Models
    module MuckRecommendationOwner

      # gives the class it is called on personalized recommendations
      extend ActiveSupport::Concern
      
      included do
        has_many :personal_recommendations, :as => :personal_recommendable
      end
      
    end
  end
end