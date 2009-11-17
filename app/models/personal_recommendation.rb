class PersonalRecommendation < ActiveRecord::Base
  belongs_to :entry, :foreign_key => 'destination_id', :conditions => [:destination_type => 'Entry']
end
