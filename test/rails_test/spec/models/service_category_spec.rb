# == Schema Information
#
# Table name: service_categories
#
#  id   :integer(4)      not null, primary key
#  name :string(255)     not null
#  sort :integer(4)      default(0)
#

require File.dirname(__FILE__) + '/../spec_helper'

class ServiceCategoryTest < ActiveSupport::TestCase

  describe "service category instance" do
    it { should have_many :services }
    should_scope_sorted
  end
  
end
