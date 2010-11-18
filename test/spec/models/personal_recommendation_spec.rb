require File.dirname(__FILE__) + '/../spec_helper'

describe PersonalRecommendation do
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
        recommendation.save.should be_true
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
      it { should scope_newer_than }
      it { should scope_by_newest }
      
      describe "entries" do
        it "should return an entry" do
          @user.personal_recommendations.entries_only.should include(@entry_recommendation)
        end
        it "should not return a user" do
          @user.personal_recommendations.entries_only.should_not include(@user_recommendation)
        end
      end
      describe "users" do
        it "should return an user" do
          @user.personal_recommendations.users.should include(@user_recommendation)
        end
        it "should not return an entry" do
          @user.personal_recommendations.users.should_not include(@entry_recommendation)
        end
      end      
    end
    
  end
end
