require File.dirname(__FILE__) + '/../spec_helper'

class PersonalRecommendationTest < ActiveSupport::TestCase
  describe "personal recommendations" do
    before do
      @user = Factory(:user)
    end
    
    describe "include MuckServices::Models::MuckRecommendationOwner" do
      before do
        @entry = Factory(:entry)
      end
      it "should create a personal recommendation" do
        recommendation = @user.personal_recommendations.build(:destination => @entry)
        assert recommendation.save
      end
    end
    
    describe "include MuckServices::Models::MuckRecommendation" do
      before do
        @recommended_user = Factory(:user)
      end
      it "should make user recommended" do
        recommendation = @user.personal_recommendations.create(:destination => @recommended_user)
        @recommended_user.recommended_to.should include(recommendation)
      end
    end
    
    describe "named scopes" do
      before do
        @entry = Factory(:entry)
        @entry_old = Factory(:entry)
        @recommended_user = Factory(:user)
        @entry_recommendation = @user.personal_recommendations.create(:destination => @entry)
        @user_recommendation = @user.personal_recommendations.create(:destination => @recommended_user, :created_at => 1.day.ago)
        @old_recommendation = @user.personal_recommendations.create(:destination => @entry_old, :created_at => 3.weeks.ago)
      end

      describe "entries" do
        it "should return an entry" do
          @user.personal_recommendations.entries_only.should include(@entry_recommendation)
        end
        it "should not return a user" do
          !@user.personal_recommendations.entries_only.should include(@user_recommendation)
        end
      end
      describe "users" do
        it "should return an user" do
          @user.personal_recommendations.users.should include(@user_recommendation)
        end
        it "should not return an entry" do
          !@user.personal_recommendations.users.should include(@entry_recommendation)
        end
      end
      describe "limited" do
        it "should only return a limited number of recommendations" do
          @user.personal_recommendations.limit(1).length.should == 1
        end
      end
      describe "recent" do
        it "should return recent recommendations" do
          @user.personal_recommendations.recent.should include(@entry_recommendation)
        end
        it "should not return old recommendations" do
          !@user.personal_recommendations.recent.should include(@old_recommendation)
        end
      end
      describe "newest" do
        it "should order recommendations by newest" do
          recommendations = @user.personal_recommendations.by_newest
          assert recommendations[0].created_at > recommendations[1].created_at
        end
      end
      
    end
    
  end
end
