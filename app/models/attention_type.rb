# == Schema Information
#
# Table name: attention_types
#
#  id             :integer(4)      not null, primary key
#  name           :string(255)
#  default_weight :integer(4)
#


class AttentionType < ActiveRecord::Base
  WRITE     = 1
  BOOKMARK  = 2
  SEARCH    = 3
  CLICK     = 4
  SHARE     = 5
  DISCUSS   = 6
end
