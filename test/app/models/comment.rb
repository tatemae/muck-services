# == Schema Information
#
# Table name: comments
#
#  id               :integer(4)      not null, primary key
#  commentable_id   :integer(4)      default(0)
#  commentable_type :string(15)      default("")
#  body             :text
#  user_id          :integer(4)
#  parent_id        :integer(4)
#  lft              :integer(4)
#  rgt              :integer(4)
#  is_denied        :integer(4)      default(0), not null
#  is_reviewed      :boolean(1)
#  created_at       :datetime
#  updated_at       :datetime
#

class Comment < ActiveRecord::Base
  include MuckActivities::Models::MuckActivityItem
  include MuckComments::Models::MuckComment
  include MuckServices::Models::MuckServicesComment
end
