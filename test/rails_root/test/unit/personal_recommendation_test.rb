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
      setup do
        @entry = Factory(:entry)
        @entry_old = Factory(:entry)
        @recommended_user = Factory(:user)
        @entry_recommendation = @user.personal_recommendations.create(:destination => @entry)
        @user_recommendation = @user.personal_recommendations.create(:destination => @recommended_user, :created_at => 1.day.ago)
        @old_recommendation = @user.personal_recommendations.create(:destination => @entry_old, :created_at => 3.weeks.ago)
      end

      context "entries" do
        should "return an entry" do
          assert @user.personal_recommendations.entries_only.include?(@entry_recommendation)
        end
        should "not return a user" do
          assert !@user.personal_recommendations.entries_only.include?(@user_recommendation)
        end
      end
      context "users" do
        should "return an user" do
          assert @user.personal_recommendations.users.include?(@user_recommendation)
        end
        should "not return an entry" do
          assert !@user.personal_recommendations.users.include?(@entry_recommendation)
        end
      end
      context "limited" do
        should "only return a limited number of recommendations" do
          assert_equal 1, @user.personal_recommendations.limit(1).length
        end
      end
      context "recent" do
        should "return recent recommendations" do
          assert @user.personal_recommendations.recent.include?(@entry_recommendation)
        end
        should "not return old recommendations" do
          assert !@user.personal_recommendations.recent.include?(@old_recommendation)
        end
      end
      context "newest" do
        should "order recommendations by newest" do
          recommendations = @user.personal_recommendations.newest
          assert recommendations[0].created_at > recommendations[1].created_at
        end
      end
      
    end
    
  end
end
