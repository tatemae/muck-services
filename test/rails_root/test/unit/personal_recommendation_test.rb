require File.dirname(__FILE__) + '/../test_helper'

class PersonalRecommendationTest < ActiveSupport::TestCase
  context "personal recommendations" do
    setup do
      @user = Factory(:user)
    end
    
    context "has_muck_recommendations" do
      setup do
        @entry = Factory(:entry)
      end
      should "create a personal recommendation" do
        recommendation = @user.personal_recommendations.build(:destination => @entry)
        assert recommendation.save
      end
    end
    
    context "acts_as_muck_recommendation" do
      setup do
        @recommended_user = Factory(:user)
      end
      should "make user recommended" do
        recommendation = @user.personal_recommendations.create(:destination => @recommended_user)
        assert @recommended_user.recommended_to.include?(recommendation)
      end
    end
    
    context "named scopes" do
      context "entries" do
        setup do
          @entry = Factory(:entry)
          @recommendation = @user.personal_recommendations.build(:destination => @entry)
        end
        should "return an entry" do
          assert @user.personal_recommendations.entries.include?(@recommendation)
        end
      end
    end
    
  end
end




