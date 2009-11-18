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
    
  end
  
end
