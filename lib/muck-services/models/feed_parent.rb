# include MuckServices::Models::MuckFeedParent
module MuckServices
  module Models
    module MuckFeedParent
      # Gives the class it is called on access to feeds.
      # Retrieve feeds via object.feeds. ie @user.feeds.
      # This is used to indicate which feeds a user would like to have access to.

      extend ActiveSupport::Concern
      
      included do
        has_many :feed_parents, :as => :ownable
        has_many :feeds, :through => :feed_parents, :order => 'created_at desc'
      end

    end
  end
end