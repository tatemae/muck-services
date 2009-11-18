# == Schema Information
#
# Table name: attentions
#
#  id                 :integer(4)      not null, primary key
#  attentionable_id   :integer(4)
#  attentionable_type :string(255)     default("User")
#  entry_id           :integer(4)
#  attention_type_id  :integer(4)
#  weight             :integer(4)      default(5)
#  created_at         :datetime
#

class Attention < ActiveRecord::Base
end
