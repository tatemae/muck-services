# == Schema Information
#
# Table name: entries
#
#  id                      :integer(4)      not null, primary key
#  feed_id                 :integer(4)      not null
#  permalink               :string(2083)    default(""), not null
#  author                  :string(2083)
#  title                   :text            default(""), not null
#  description             :text
#  content                 :text
#  unique_content          :boolean(1)
#  published_at            :datetime        not null
#  entry_updated_at        :datetime
#  harvested_at            :datetime
#  oai_identifier          :string(2083)
#  language_id             :integer(4)
#  direct_link             :string(2083)
#  indexed_at              :datetime        default(Fri Jan 01 01:01:01 UTC 1971), not null
#  relevance_calculated_at :datetime        default(Fri Jan 01 01:01:01 UTC 1971), not null
#  popular                 :text
#  relevant                :text
#  other                   :text
#  grain_size              :string(255)     default("unknown")
#  comment_count           :integer(4)      default(0)
#

require File.dirname(__FILE__) + '/../spec_helper'

describe Entry do

  describe "entry instance" do
    before do
      @entry = Factory(:entry)
    end
    
    it { should belong_to :feed }

    describe "recommender_entry" do
      it "should return an entry if the direct_link matches the specified uri" do
        uri = Factory.next(:uri)
        e = Factory.create(:entry, :direct_link => uri)
        Entry.recommender_entry(uri).id.should == e.id
      end

      it "should return an entry if the permalink matches the specified uri" do
        uri = Factory.next(:uri)
        e = Factory.create(:entry, :permalink => uri)
        Entry.recommender_entry(uri).id.should == e.id
      end

      it "should return an empty entry with the specified uri if the specified uri doesn't match" do
        uri = Factory.next(:uri)
        e = Factory.create(:entry, :permalink => uri)
        Entry.recommender_entry(uri).should_not be_nil
        Entry.recommender_entry(uri).permalink.should == uri
      end
    end

    describe "resource_uri" do
      it "should return the permalink when no direct_link is specified" do
        @entry.direct_link = nil
        @entry.resource_uri.should == @entry.permalink
      end

      it "should return the direct_link when a direct_link is specified" do
        @entry.direct_link = Factory.next(:uri)
        @entry.resource_uri.should == @entry.direct_link
      end
    end
    
    describe "search" do
      # it "should search indexes for ruby" do
      #   Entry.search('ruby', 'all', 'en', 10, 0)
      # end
      it "should raise invalid language error" do
        lambda{
          Entry.search('ruby', 'all', 'foo', 10, 0)          
        }.should raise_error(MuckServices::Exceptions::LanguageNotSupported)
      end
    end

    describe "normalized_uri" do
      it "should remove the trailing file name from any url that ends in index.*" do
        index_uri = 'http://example.com/some_dir/'
        ['html','aspx','shtm','htm','asp','php','cfm','jsp','shtml','jhtml'].each { |ext|
          Entry.normalized_uri(index_uri + 'index.' + ext).should == index_uri
        }
      end
    end

    describe "recommendation requested omitting certain feeds" do
      it "should not contain entries from those feeds" do
        feed1_id = Factory(:feed).id
        feed2_id = Factory(:feed).id
        feed1_id.should != feed2_id
        Recommendation.create(:entry_id => @entry.id, :dest_entry_id => Factory.create(:entry, :feed_id => feed1_id).id)
        Recommendation.create(:entry_id => @entry.id, :dest_entry_id => Factory.create(:entry, :feed_id => feed2_id).id)
        r = @entry.related_entries.top(false, 5, feed2_id.to_s)
        r.length.should == 1
        r.each { |e| assert_not_equal feed2_id, e.feed_id}
      end
    end

    describe "with 3 recommendations" do
      before do
        3.times { |n| Recommendation.create(:entry_id => @entry.id,
                      :dest_entry_id => Factory(:entry).id, :relevance => n.to_f/10.0) }
      end

      it "should have 3 related_entries" do
        @entry.related_entries.top.length.should == 3
      end

      it "should return only 2 if specified" do
        @entry.related_entries.top(true,2).length.should == 2
      end

      it "should return results in order of relevance by default" do
        related_entries = @entry.related_entries.top
        assert related_entries[1].relevance < related_entries[0].relevance
        assert related_entries[2].relevance < related_entries[1].relevance
      end

    end
    
    describe "recommendation requested without details" do
      it "should not have an author" do
        Recommendation.create(:entry_id => @entry.id,
                              :dest_entry_id => Factory.create(:entry, :author => Factory.next(:name)).id,
                              :relevance => '.3')
        lambda{
          @entry.related_entries.top.first.author          
        }.should raise_error(ActiveRecord::MissingAttributeError)
      end

      it "should have basic fields" do
        title = Factory.next(:name)
        collection = Factory.next(:name)
        feed_id = Factory(:feed, :short_title => collection).id
        dest_entry_id = Factory.create(:entry, :title => title, :feed_id => feed_id).id
        relevance = '.3'
        recommendation_id = Recommendation.create(:entry_id => @entry.id, :relevance => relevance,
               :dest_entry_id => dest_entry_id).id.to_s
        r = @entry.related_entries.top(true).first
        lambda do
          r.recommendation_id.should == recommendation_id
          r.relevance.to_f.should == relevance.to_f
          r.title.should == title
          r.collection.should == collection
          r.dest_entry_id.should_not be_nil
        end.should_not raise_error
      end
    end

    describe "recommendation requested with details" do
      it "should have basic and detailed fields" do
        title = Factory.next(:name)
        collection = Factory.next(:name)
        author = Factory.next(:name)
        published_at = DateTime.now
        clicks = 23
        average_time_at_dest = 44
        description = Factory.next(:name)
        permalink = Factory.next(:uri)
        direct_uri = Factory.next(:uri)
        feed_id = Factory(:feed, :short_title => collection).id
        relevance = '.3'
        dest_entry_id = Factory.create(:entry, :feed_id => feed_id, :title => title,
               :author => author, :published_at => published_at, :permalink => permalink,
               :direct_link => direct_uri, :description => description).id
        recommendation_id = Recommendation.create(:entry_id => @entry.id, :relevance => relevance,
               :avg_time_at_dest => average_time_at_dest, :clicks => clicks, :dest_entry_id => dest_entry_id).id.to_s
        r = @entry.related_entries.top(true).first
        lambda do
          r.recommendation_id.should == recommendation_id
          r.relevance.to_f.should == relevance.to_f
          r.title.should == title
          r.collection.should == collection
          r.dest_entry_id.should_not be_nil

          r.author.should == author
#          r.published_at.should == published_at
          r.clicks.to_i.should == clicks
          r.permalink.should == permalink
          r.direct_uri.should == direct_uri
          r.average_time_at_dest.to_i.should == average_time_at_dest
          r.description.should == description
        end.should_not raise_error
      end
    end

  end
  
end
