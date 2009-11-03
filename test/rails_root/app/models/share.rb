# == Schema Information
#
# Table name: shares
#
#  id            :integer(4)      not null, primary key
#  uri           :string(2083)    default(""), not null
#  title         :string(255)
#  message       :text
#  shared_by_id  :integer(4)      not null
#  created_at    :datetime
#  updated_at    :datetime
#  comment_count :integer(4)      default(0)
#  entry_id      :integer(4)
#

class Share < ActiveRecord::Base
  acts_as_activity_item
  acts_as_muck_share
  acts_as_muck_services_share # must be called after acts_as_muck_share
end
