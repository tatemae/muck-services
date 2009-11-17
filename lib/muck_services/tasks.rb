require 'rake'
require 'rake/tasklib'
require 'fileutils'

module MuckServices
  class Tasks < ::Rake::TaskLib
    def initialize
      define
    end

    private
    def define

      namespace :muck do

        namespace :services do

          desc "Imports attention data for use in testing"
          task :import_attention => :environment do
            require 'active_record/fixtures'
            ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
            yml = File.join(RAILS_ROOT, 'db', 'bootstrap', 'attention')
            Fixtures.new(Attention.connection,"attention",Attention,yml).insert_fixtures
          end

          namespace :db do

            desc "Flags the languages that the muck raker supports"
            task :populate => :environment do
              require 'active_record/fixtures'
              ['en', 'es', 'zh-CN', 'fr', 'ja', 'de', 'ru', 'nl'].each{|l|
                r = Language.first(:one, :conditions => "locale = '#{l}'")
                if r
                  r.update_attribute(:muck_raker_supported, true)
                else
                  puts "Unable to find languages to flag. You probably need to run rake muck:db:populate"
                  break
                end
              }
            end

            desc "Loads some feeds oai endpoints to get things started"
            task :bootstrap => :environment do
              require 'active_record/fixtures'
              ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

              # import the bootstrap db entries
              OaiEndpoint.delete_all
              yml = File.join(File.dirname(__FILE__), '..', '..', 'db', 'bootstrap',"oai_endpoints")
              Fixtures.new(OaiEndpoint.connection,"oai_endpoints",OaiEndpoint,yml).insert_fixtures

              Feed.delete_all
              yml = File.join(File.dirname(__FILE__), '..', '..', 'db', 'bootstrap',"feeds")
              Fixtures.new(Feed.connection,"feeds",Feed,yml).insert_fixtures

              ServiceCategory.delete_all
              yml = File.join(File.dirname(__FILE__), '..', '..', 'db', 'bootstrap',"service_categories")
              Fixtures.new(Service.connection,"service_categories",ServiceCategory,yml).insert_fixtures

              Service.delete_all
              yml = File.join(File.dirname(__FILE__), '..', '..', 'db', 'bootstrap',"services")
              Fixtures.new(Service.connection,"services",Service,yml).insert_fixtures

            end

            desc "Deletes and reloads all services and service categories"
            task :bootstrap_services => :environment do
              require 'active_record/fixtures'
              ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

              ServiceCategory.delete_all
              yml = File.join(File.dirname(__FILE__), '..', '..', 'db', 'bootstrap',"service_categories")
              Fixtures.new(Service.connection,"service_categories",ServiceCategory,yml).insert_fixtures

              Service.delete_all
              yml = File.join(File.dirname(__FILE__), '..', '..', 'db', 'bootstrap',"services")
              Fixtures.new(Service.connection,"services",Service,yml).insert_fixtures

            end

          end

          desc "Sync files from muck services."
          task :sync do
            path = File.join(File.dirname(__FILE__), *%w[.. ..])
            system "rsync -ruv #{path}/db ."
            system "rsync -ruv #{path}/public ."
          end

          desc "Create global_feeds aggregation and add feeds to it"
          task :create_global_feeds => :environment do
            admin_id = User.find_by_login('admin').id
                    global_aggregation = Aggregation.create(:title => 'global_feeds', :terms => 'global_feeds',
                          :description => 'Feeds included in the site indexes.',
                          :ownable_id => admin_id, :ownable_type => 'User')
            global_aggregation = Aggregation.find_by_title('global_feeds')
            global_aggregation.feeds << Feed.find(:all, :conditions => "uri LIKE 'http://www.oercommons.org%' OR id < 1047364815")
            global_aggregation.save!
            AggregationFeed.update_all("feed_type = 'Feed'")
            OaiEndpoint.find(:all).each do |ep|
              AggregationFeed.create(:aggregation_id => global_aggregation.id, :feed_type => 'OaiEndpoint', :feed_id => ep.id)
            end
          end

          desc "Add attention types"
          task :add_attention_types => :environment do
            AttentionType.create(:id => AttentionType::WRITE, :name => 'write', :default_weight => 10)
            AttentionType.create(:id => AttentionType::BOOKMARK, :name => 'bookmark', :default_weight => 5)
            AttentionType.create(:id => AttentionType::SEARCH, :name => 'search', :default_weight => 3)
            AttentionType.create(:id => AttentionType::CLICK, :name => 'click', :default_weight => 4)
            AttentionType.create(:id => AttentionType::SHARE, :name => 'share', :default_weight => 6)
            AttentionType.create(:id => AttentionType::DISCUSS, :name => 'discuss', :default_weight => 7)
          end

        end

      end

    end
  end
end
MuckServices::Tasks.new