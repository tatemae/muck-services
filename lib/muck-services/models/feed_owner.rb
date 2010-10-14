# include MuckServices::Models::MuckFeedOwner
module MuckServices
  module Models
    module MuckFeedOwner
      
      # Adds identity feeds to a given object.  The feeds
      # attached to the object in this way are then assumed to be produced by the object.
      # For example, if a user writes a blog the blog could be associated with the user in this way.
      
      extend ActiveSupport::Concern
      
      included do
        has_many :identity_feeds, :as => :ownable
        has_many :own_feeds, :through => :identity_feeds, :source => :feed, :order => 'created_at desc'
      end

      # Override this method to define whether or not a user can add feeds.
      def can_add_feeds?
        false
      end
      
    end
  end
end