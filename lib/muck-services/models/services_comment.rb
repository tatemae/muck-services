# include MuckServices::Models::MuckServicesComment
module MuckServices
  module Models
    module MuckServicesComment

      extend ActiveSupport::Concern
              
      def after_create
        if self.commentable.is_a?(Entry)
          return if self.user.blank?
          # Create a new entry_comment activity.  Attach the activity to the entry via self.commentable
          # Include all users in the discussion ie all users from all comments attached to self.commentable
          feed_to = []
          feed_to << self.user.feed_to
          self.commentable.comments.each do |c|
            feed_to << c.user if !c.user.blank?
          end
          add_activity(feed_to, self.user, self, 'entry_comment', '', '', nil, self.commentable)
        end
      end
      
    end
  end
end