require 'fileutils'

namespace :muck do
  
  desc "Sync files from muck services."
  namespace :sync do
    task :services do
      path = File.join(File.dirname(__FILE__), *%w[.. ..])
      system "rsync -ruv #{path}/db ."
      system "rsync -ruv #{path}/public ."
      puts "Copied migrations and public files from muck-services"
    end
  end
  
  namespace :services do

    namespace :db do

      desc "Flags the languages that the muck raker supports"
      task :populate => :environment do
        require 'active_record/fixtures'
        ['en', 'es', 'zh-CN', 'fr', 'ja', 'de', 'ru', 'nl'].each{|l|
          r = Language.where("locale='#{l}'").first
          if r
            r.update_attribute(:muck_raker_supported, true)
          else
            puts "Unable to find languages to flag. You probably need to run rake muck:db:populate"
            break
          end
        }
      end

      desc "Loads some feeds and oai endpoints to get things started (this should be run before muck:services:db:create_global_aggregation_feeds)"
      task :bootstrap => :environment do
        require 'active_record/fixtures'
        ActiveRecord::Base.establish_connection(::Rails.env)

        # import the bootstrap db entries
        OaiEndpoint.delete_all
        yml = File.join(File.dirname(__FILE__), '..', '..', 'db', 'bootstrap',"oai_endpoints")
        Fixtures.new(OaiEndpoint.connection,"oai_endpoints",OaiEndpoint,yml).insert_fixtures

        Feed.delete_all
        yml = File.join(File.dirname(__FILE__), '..', '..', 'db', 'bootstrap',"feeds")
        Fixtures.new(Feed.connection,"feeds",Feed,yml).insert_fixtures

        puts "Added some feeds and oai endpoints to the database"
      end

      desc "Deletes and reloads all services and service categories"
      task :bootstrap_services => :environment do
        require 'active_record/fixtures'
        ActiveRecord::Base.establish_connection(::Rails.env)

        ServiceCategory.delete_all
        yml = File.join(File.dirname(__FILE__), '..', '..', 'db', 'bootstrap',"service_categories")
        Fixtures.new(Service.connection,"service_categories",ServiceCategory,yml).insert_fixtures

        Service.delete_all
        yml = File.join(File.dirname(__FILE__), '..', '..', 'db', 'bootstrap',"services")
        Fixtures.new(Service.connection,"services",Service,yml).insert_fixtures
        puts "Added services and service categories"
      end

      desc "Creates a global feeds aggregation and adds all existing feeds to it"
      task :create_global_feeds_aggregation => :environment do
        if Aggregation.find_by_title('global_feeds') == nil
          global_feeds_id = Aggregation.create(:title => 'global_feeds', :terms => 'global_feeds',
                    :description => 'Feeds included in the site indexes.').id
          Feed.find(:all).each { |feed| AggregationFeed.create(:feed_id => feed.id, :aggregation_id => global_feeds_id) }
          puts "Added a global feed aggregation and added all existing feeds to it"
        else
          puts "The global_feeds aggregation already exists. Delete the global aggregation and try again."
        end
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
      puts "Added attention types"
    end

    desc "Imports attention data for use in testing"
    task :import_attention => :environment do
      require 'active_record/fixtures'
      ActiveRecord::Base.establish_connection(::Rails.env)
      yml = File.join(RAILS_ROOT, 'db', 'bootstrap', 'attention')
      Fixtures.new(Attention.connection,"attention",Attention,yml).insert_fixtures
      puts "Added attention data"
    end

  end

end