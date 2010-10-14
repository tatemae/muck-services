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

require File.dirname(__FILE__) + '/../spec_helper'

class RecommendationTest < ActiveSupport::TestCase

  describe "recommendation" do
    before do
      @recommendation = Factory(:recommendation)
    end

    

    it { should belong_to :entry }
    it { should belong_to :dest_entry }
  end

end