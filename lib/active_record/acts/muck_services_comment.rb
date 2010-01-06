module ActiveRecord
  module Acts #:nodoc:
    module MuckServicesComment # :nodoc:

      def self.included(base)
        base.extend(ClassMethods)
      end
  
      module ClassMethods

        def acts_as_muck_services_comment(options = {})
          include ActiveRecord::Acts::MuckServicesComment::InstanceMethods
          extend ActiveRecord::Acts::MuckServicesComment::SingletonMethods
        end
      end
      
      # class methods
      module SingletonMethods
      end

      module InstanceMethods
        
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
end