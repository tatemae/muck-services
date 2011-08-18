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

class Entry < ActiveRecord::Base
  
  unloadable
  
  belongs_to :feed
  belongs_to :language
  has_many :activities, :as => :attachable, :dependent => :destroy
  has_many :attentions, :dependent => :destroy
  has_many :personal_recommendations, :as => :destination

  has_many :related_to, :foreign_key => 'entry_id', :class_name => 'Recommendation'
  has_many :related_entries, :through => :related_to, :source => :dest_entry do
    def top(details=false, limit=5, omit_feeds=nil, order='rank asc, relevance desc')
      select = 'entries.feed_id, recommendations.id recommendation_id, recommendations.relevance, ' +
               'entries.title, feeds.short_title collection, recommendations.dest_entry_id '
      select << ', entries.author, entries.published_at, recommendations.clicks, entries.permalink, ' +
                'entries.direct_link direct_uri, ' +
                'recommendations.avg_time_at_dest average_time_at_dest, entries.description' if details
      conditions = omit_feeds == nil ? '' : "entries.feed_id NOT IN (#{omit_feeds.gsub(/[^0-9,]/,'')})"
      joins = 'INNER JOIN feeds ON entries.feed_id = feeds.id'
      find(:all, :select => select, :joins => joins, :conditions => conditions, :limit => limit, :order => order)
    end
  end

  include MuckComments::Models::MuckCommentable
  acts_as_taggable
  include MuckServices::Models::MuckRecommendation
  
  @@min_secs_tracked = 5
  @@max_secs_tracked = 120
  @@default_time_on_page = 60.0
  
  if MuckServices.configuration.enable_solr && MuckServices.configuration.enable_sunspot
    fields = [{:aggregation => :integer}, {:feed_id => :integer}, {:grain_size => :string}, {:tags => :string}]
    if MuckServices.configuration.enable_solr
      require 'acts_as_solr'
      acts_as_solr({:if => false, :fields => fields}, {:type_field => :type_s})
    elsif MuckServices.configuration.enable_sunspot
      require 'sunspot'
      searchable do
        fields.each do |field|
          text field
        end
      end
    end
  end
  
  def self.search(search_terms, grain_size = nil, language = "en", limit = 10, offset = 0, operator = :or)
    raise MuckServices::Exceptions::LanguageNotSupported, I18n.t('muck.services.language_not_supported') unless Recommender::Languages.supported_languages.include?(language)
    query = ((!grain_size.nil? && grain_size != 'all') ? (search_terms + ") AND (grain_size:#{grain_size}") : search_terms) + ") AND (aggregation:#{Aggregation.global_feeds_id}"
    return find_by_solr(query, :limit => limit, :offset => offset, :scores => true,
        :select => "entries.id, entries.title, entries.permalink, entries.direct_link, entries.published_at, entries.description, entries.feed_id, feeds.short_title AS collection",
        :joins => "INNER JOIN feeds ON feeds.id = entries.feed_id", :core => language, :operator => operator)
  end

  def resource_uri
    self.direct_link.nil? ? self.permalink : self.direct_link
  end

  def self.normalized_uri(uri)
    uri.sub(/index.?\.(html|aspx|shtm|htm|asp|php|cfm|jsp|shtml|jhtml)$/, '')
  end

  def self.recommender_entry(uri)
    uri = normalized_uri(uri)
    Entry.find(:first, :conditions => ['permalink = ? OR direct_link = ?', uri, uri], :order => 'direct_link IS NULL DESC') || Entry.new(:permalink => uri)
  end
  
  def self.track_time_on_page(session, uri)
    recommendation_id = session[:last_clicked_recommendation]
    if !recommendation_id.nil?
      time_on_page = (Time.now - session[:last_clicked_recommendation_time].to_f).to_i

      # if they spend less or more than time is reasonable, we don't infer anything
      if time_on_page > @@min_secs_tracked and time_on_page < @@max_secs_tracked
        if normalized_uri(uri) != session[:last_clicked_recommendation_uri]
          recommendation = Recommendation.find(recommendation_id)
          entry = Entry.find(recommendation.entry_id)
          new_avg = (recommendation.avg_time_at_dest*recommendation.clicks - @@default_time_on_page + time_on_page)/recommendation.clicks
          recommendation.avg_time_at_dest = new_avg
          recommendation.save!
          session[:last_clicked_recommendation] = nil
        end
      else
        session[:last_clicked_recommendation] = nil if time_on_page > @@min_secs_tracked
      end
    end
  end

  def self.track_click(session, recommendation_id, referrer, redirect_type = "direct_link", requester = "unknown", user_agent = "unknown")
    # look up the recommendation
    recommendation = Recommendation.find(recommendation_id)
    return "" if !recommendation

    # get the list of recommendations that have been clicked during this session
    clicks = session[:rids] || Array.new

    # redirect to our frame page
    redirect = "/visits/#{recommendation.dest_entry_id}"

    # track the time on the last page
    track_time_on_page(session, redirect)

    # if this is first time the user clicked on this recommendation during this session
    if !clicks.include?(recommendation_id)

      # add this recommendation to the end of the list
      clicks << recommendation_id
      session[:rids] = clicks

      # update the click time
      recommendation.avg_time_at_dest = ((recommendation.avg_time_at_dest*recommendation.clicks) + @@default_time_on_page)/(recommendation.clicks + 1)
      recommendation.clicks += 1
      recommendation.save!

      # store info about this click in the session
      now = Time.now
      session[:last_clicked_recommendation] = recommendation_id
      session[:last_clicked_recommendation_time] = now
      session[:last_clicked_recommendation_uri] = redirect

      # track the click in the db
      Click.create(:recommendation_id => recommendation_id, :when => now, :referrer => referrer, :requester => requester, :user_agent => user_agent)
    end

    return redirect
  end

  def self.real_time_recommendations(uri, language='en', limit=5, details=false, options = {})
    raise MuckServices::Exceptions::LanguageNotSupported, I18n.t('muck.services.language_not_supported') unless Recommender::Languages.supported_languages.include?(language)
    fields = "entries.id, entries.title, entries.permalink, entries.direct_link, feeds.short_title AS collection"
    fields << ", entries.published_at, entries.description, entries.author" if details == true 
    more_like_this(uri, options.merge(:select => fields, :joins => "INNER JOIN feeds ON feeds.id = entries.feed_id", :core => language, :limit => limit))
  end

end
