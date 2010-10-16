# == Schema Information
#
# Table name: service_categories
#
#  id   :integer(4)      not null, primary key
#  name :string(255)     not null
#  sort :integer(4)      default(0)
#

class ServiceCategory < ActiveRecord::Base
  scope :sorted, order("sort ASC")
  has_many :services, :order => 'sort ASC'
  has_many :identity_services, :class_name => 'Service', :order => 'sort ASC', :conditions => ['use_for = ?', 'identity']
  has_many :tag_services, :class_name => 'Service', :order => 'sort ASC', :conditions => ['use_for = ?', 'tags']
end
