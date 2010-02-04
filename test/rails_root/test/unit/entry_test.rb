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

require File.dirname(__FILE__) + '/../test_helper'

class EntryTest < ActiveSupport::TestCase

  context "entry instance" do
    setup do
      @entry = Factory(:entry)
    end
    
    subject { @entry }
    
    should_belong_to :feed


    context "recommender_entry" do
      should "return an entry if the direct_link matches the specified uri" do
        uri = Factory.next(:uri)
        e = Factory.create(:entry, :direct_link => uri)
        assert_equal e.id, Entry.recommender_entry(uri).id
      end

      should "return an entry if the permalink matches the specified uri" do
        uri = Factory.next(:uri)
        e = Factory.create(:entry, :permalink => uri)
        assert_equal e.id, Entry.recommender_entry(uri).id
      end

      should "return an empty entry with the specified uri if the specified uri doesn't match" do
        uri = Factory.next(:uri)
        e = Factory.create(:entry, :permalink => uri)
        assert_not_nil Entry.recommender_entry(uri)
        assert_equal uri, Entry.recommender_entry(uri).permalink
      end
    end

    context "resource_uri" do
      should "return the permalink when no direct_link is specified" do
        @entry.direct_link = nil
        assert_equal @entry.permalink, @entry.resource_uri
      end

      should "return the direct_link when a direct_link is specified" do
        @entry.direct_link = Factory.next(:uri)
        assert_equal @entry.direct_link, @entry.resource_uri
      end
    end
    
    context "search" do
      # should "search indexes for ruby" do
      #   Entry.search('ruby', 'all', 'en', 10, 0)
      # end
      should "raise invalid language error" do
        assert_raise(MuckServices::Exceptions::LanguageNotSupported) do
          Entry.search('ruby', 'all', 'foo', 10, 0)
        end
      end
    end

    context "normalized_uri" do
      should "remove the trailing file name from any url that ends in index.*" do
        index_uri = 'http://example.com/some_dir/'
        ['html','aspx','shtm','htm','asp','php','cfm','jsp','shtml','jhtml'].each { |ext|
          assert_equal index_uri, Entry.normalized_uri(index_uri + 'index.' + ext)
        }
      end
    end

    context "recommendation requested omitting certain feeds" do
      should "not contain entries from those feeds" do
        feed1_id = Factory(:feed).id
        feed2_id = Factory(:feed).id
        assert_not_equal feed1_id, feed2_id
        Recommendation.create(:entry_id => @entry.id, :dest_entry_id => Factory.create(:entry, :feed_id => feed1_id).id)
        Recommendation.create(:entry_id => @entry.id, :dest_entry_id => Factory.create(:entry, :feed_id => feed2_id).id)
        r = @entry.related_entries.top(false, 5, feed2_id.to_s)
        assert_equal 1, r.length
        r.each { |e| assert_not_equal feed2_id, e.feed_id}
      end
    end

    context "with 3 recommendations" do

      setup do
        3.times { |n| Recommendation.create(:entry_id => @entry.id,
                      :dest_entry_id => Factory(:entry).id, :relevance => n.to_f/10.0) }
      end

      should "have 3 related_entries" do
        assert_equal 3, @entry.related_entries.top.length
      end

      should "return only 2 if specified" do
        assert_equal 2, @entry.related_entries.top(true,2).length
      end

      should "return results in order of relevance by default" do
        related_entries = @entry.related_entries.top
        assert related_entries[1].relevance < related_entries[0].relevance
        assert related_entries[2].relevance < related_entries[1].relevance
      end

    end
    
    context "recommendation requested without details" do
      should "not have an author" do
        Recommendation.create(:entry_id => @entry.id,
                              :dest_entry_id => Factory.create(:entry, :author => Factory.next(:name)).id,
                              :relevance => '.3')
        assert_raise ActiveRecord::MissingAttributeError do
          @entry.related_entries.top.first.author
        end
      end

      should "have basic fields" do
        title = Factory.next(:name)
        collection = Factory.next(:name)
        feed_id = Factory(:feed, :short_title => collection).id
        dest_entry_id = Factory.create(:entry, :title => title, :feed_id => feed_id).id
        relevance = '.3'
        recommendation_id = Recommendation.create(:entry_id => @entry.id, :relevance => relevance,
               :dest_entry_id => dest_entry_id).id.to_s
        r = @entry.related_entries.top(true).first
        assert_nothing_raised do
          assert_equal recommendation_id, r.recommendation_id
          assert_equal relevance.to_f, r.relevance.to_f
          assert_equal title, r.title
          assert_equal collection, r.collection
          assert_not_nil r.dest_entry_id
        end
      end
    end

    context "recommendation requested with details" do
      should "have basic and detailed fields" do
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
        assert_nothing_raised do
          assert_equal recommendation_id, r.recommendation_id
          assert_equal relevance.to_f, r.relevance.to_f
          assert_equal title, r.title
          assert_equal collection, r.collection
          assert_not_nil r.dest_entry_id

          assert_equal author, r.author
#          assert_equal published_at, r.published_at
          assert_equal clicks, r.clicks.to_i
          assert_equal permalink, r.permalink
          assert_equal direct_uri, r.direct_uri
          assert_equal average_time_at_dest, r.average_time_at_dest.to_i
          assert_equal description, r.description
        end
      end
    end

  end
  
end
