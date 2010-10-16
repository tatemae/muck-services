# include MuckServices::Models::MuckRecommendation
module MuckServices
  module Models
    module MuckRecommendation

      extend ActiveSupport::Concern
      
      included do
        has_many :recommended_to, :as => :destination, :class_name => 'PersonalRecommendation'
      end
      
    end
  end
end