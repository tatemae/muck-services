# == Schema Information
#
# Table name: recommendations
#
#  id               :integer(4)      not null, primary key
#  entry_id         :integer(4)
#  dest_entry_id    :integer(4)
#  rank             :integer(4)
#  relevance        :decimal(8, 6)   default(0.0)
#  clicks           :integer(4)      default(0)
#  avg_time_at_dest :integer(4)      default(60)
#

class Recommendation < ActiveRecord::Base
  belongs_to :entry, :class_name => 'Entry', :foreign_key => 'entry_id'
  belongs_to :dest_entry, :class_name => 'Entry', :foreign_key => 'dest_entry_id'
end
