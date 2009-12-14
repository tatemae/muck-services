# == Schema Information
#
# Table name: services
#
#  id                  :integer(4)      not null, primary key
#  uri                 :string(2083)    default("")
#  name                :string(1000)    default("")
#  api_uri             :string(2083)    default("")
#  uri_template        :string(2083)    default("")
#  icon                :string(2083)    default("rss.gif")
#  sort                :integer(4)
#  requires_password   :boolean(1)
#  use_for             :string(255)
#  service_category_id :integer(4)
#  active              :boolean(1)      default(TRUE)
#  prompt              :string(255)
#  template            :string(255)
#  uri_data_template   :string(2083)    default("")
#  uri_key             :string(255)
#

require File.dirname(__FILE__) + '/../test_helper'

class ServiceTest < ActiveSupport::TestCase

  context "service instance" do

    should_belong_to :service_category
    should_scope_sorted
    
    context "named scope" do
      context "identity_services" do
        # named_scope :identity_services, :conditions => ['use_for = ?', 'identity']
      end
      context "tag_services" do
        #     named_scope :tag_services, :conditions => ['use_for = ?', 'tags']
      end
      context "sorted_id" do
        # named_scope :sorted_id, :order => "id ASC"
      end
      context "photo_services" do
        #     named_scope :photo_services, :conditions => ["service_categories.id = services.service_category_id AND service_categories.name = 'Photos'"], :include => ['service_category']
      end
    end
    
    context "photos" do
      setup do
        service_category = Factory(:service_category, :name => 'Photos')
        @service = Factory(:service, :service_category_id => service_category.id)
      end
      should "be a photo service" do
        assert @service.photo?(true)
      end
    end
    
    context "videos" do
      setup do
        service_category = Factory(:service_category, :name => 'Videos')
        @service = Factory(:service, :service_category_id => service_category.id)
      end
      should "be a video service" do
        assert @service.video?(true)
      end
    end
    
    context "bookmarks" do
      setup do
        service_category = Factory(:service_category, :name => 'Bookmarks')
        @service = Factory(:service, :service_category_id => service_category.id)
      end
      should "be a bookmark service" do
        assert @service.bookmark?(true)
      end
    end
    
    context "music" do
      setup do
        service_category = Factory(:service_category, :name => 'Music')
        @service = Factory(:service, :service_category_id => service_category.id)
      end
      should "be a music service" do
        assert @service.music?(true)
      end
    end
    
    context "news" do
      setup do
        service_category = Factory(:service_category, :name => 'News')
        @service = Factory(:service, :service_category_id => service_category.id)
      end
      should "be a news service" do
        assert @service.news?(true)
      end
    end
    
    context "blog" do
      setup do
        service_category = Factory(:service_category, :name => 'Blogging')
        @service = Factory(:service, :service_category_id => service_category.id)
      end
      should "be a blog service" do
        assert @service.blog?(true)
      end
    end
    
    context "search" do
      setup do
        service_category = Factory(:service_category, :name => 'Search')
        @service = Factory(:service, :service_category_id => service_category.id)
      end
      should "be a search service" do
        assert @service.search?(true)
      end
    end
    
    context "general" do
      setup do
        service_category = Factory(:service_category, :name => 'RSS')
        @service = Factory(:service, :service_category_id => service_category.id)
      end
      should "be a general service" do
        assert @service.general?(true)
      end
    end
    
  end
  
  context "identity services" do
    should "generate uri using blog url" do
      service = Factory(:service)
      uris = service.generate_uris('', '', TEST_URI)
      assert uris.map(&:url).include?(TEST_RSS_URI)
    end
    should "generate uri using username" do
      service = Factory(:service, :uri_data_template => TEST_USERNAME_TEMPLATE)
      uris = service.generate_uris('jbasdf', '', '')
      assert uris.map(&:url).include?(TEST_USERNAME_TEMPLATE.sub('{username}', 'jbasdf'))
    end
    should "get twitter uri from username" do
      service = Factory(:service, :uri_data_template => "http://www.twitter.com/{username}")
      uris = service.generate_uris('jbasdf', '', '')
      assert uris.map(&:url).include?("http://twitter.com/statuses/user_timeline/7219042.rss")
    end
  end
  
  context "tag services" do
    setup do
      @user = Factory(:user)
      @template = "http://example.com/{tag}.rss"
      @uri_template = "http://example.com/{tag}"
      @service = Factory(:service, :uri_data_template => @template, :uri_template => @uri_template,  :use_for => 'tags')
    end
    should "generate urls for tag" do
      tag = 'rails'
      uris = Service.generate_tag_uris(tag)
      assert uris.include?(@template.sub('{tag}', tag))
    end
    should "set display uri when building a feed" do
      tag = 'identity'
      feeds = Service.build_tag_feeds(tag, @user, nil, true)
      assert feeds.any?{|feed| feed.display_uri == (@uri_template.sub('{tag}', tag))}
    end
    should "build a feed for every tag service" do
      tag = 'cycling'
      feeds = Service.build_tag_feeds(tag, @user, nil, true)
      assert_equal Service.tag_services.length, feeds.length
      assert feeds.any?{|feed| feed.uri == (@template.sub('{tag}', tag))}
    end
    should "build a limited number of feeds for tag" do
      tag = 'ruby'
      feeds = Service.build_tag_feeds(tag, @user, [@service.id], true)
      assert_equal 1, feeds.length
      assert feeds.any?{|feed| feed.uri == (@template.sub('{tag}', tag))}
    end
    should "create a feed for every tag service" do
      tag = 'physics'
      feeds = Service.create_tag_feeds(tag, @user, nil, true)
      assert_equal Service.tag_services.length, feeds.length
      assert feeds.any?{|feed| feed.uri == (@template.sub('{tag}', tag))}
    end
    should "create a limited number of feeds for tag" do
      tag = 'math'
      feeds = Service.create_tag_feeds(tag, @user, [@service.id], true)
      assert_equal 1, feeds.length
      assert feeds.any?{|feed| feed.uri == (@template.sub('{tag}', tag))}
    end
  end
  
  context "Create feed from service" do
    setup do
      @login = 'jbasdf'
      @password = ''
      @uri_data_template = TEST_USERNAME_TEMPLATE
      @service = Factory(:service, :uri_data_template => @uri_data_template)
      @user = Factory(:user)
    end
    should "create feed from service" do
      feeds = Service.create_tag_feeds_for_service(@service, '', @login, @password, @user.id)
      feed = feeds[0]
      assert_equal @uri_data_template.sub("{username}", @login), feed.uri
      assert_equal @login, feed.login
      assert_equal @password, feed.password
      assert_equal @service.id, feed.service_id
    end
    should "create feed from service even with nil template" do
      feeds = Service.create_tag_feeds_for_service(@service, '', @login, @password, @user.id)
      feed = feeds[0]
      assert_equal @uri_data_template.sub("{username}", @login), feed.uri
      assert_equal @login, feed.login
      assert_equal @password, feed.password
      assert_equal @service.id, feed.service_id
    end
  end
  
  context "Find service by uri" do
    setup do
      Service.delete_all
    end
    teardown do
      bootstrap_services
    end
    should "find service when uri is shorter" do
      foo_service = Factory(:service, :uri => 'http://www.foo.com')
      service = Service.find_service_by_uri('foo.com', true)
      assert_equal foo_service, service
    end
    should "find service uri is longer" do
      example_service = Factory(:service, :uri => 'http://www.example.com')
      service = Service.find_service_by_uri('http://www.example.com/other_stuff', true)
      assert_equal example_service, service
    end
  end
  
  context "build" do
    setup do
      @terms = "ruby"
      @user = Factory(:user)
    end
    context "photo feeds" do
      setup do
        @feeds = Service.build_photo_feeds(@terms, @user.id)
      end
      should "only create photo feeds" do
        assert @feeds.length > 0
        assert @feeds.all? { |feed| feed.service.service_category.name == "Photos" }
      end
    end
    context "video feeds" do
      setup do
        @feeds = Service.build_video_feeds(@terms, @user.id)
      end
      should "only create video feeds" do
        assert @feeds.length > 0
        assert @feeds.all? { |feed| feed.service.service_category.name == "Videos" }
      end
    end
    context "bookmark feeds" do
      setup do
        @feeds = Service.build_bookmark_feeds(@terms, @user.id)
      end
      should "only create bookmark feeds" do
        assert @feeds.length > 0
        assert @feeds.all? { |feed| feed.service.service_category.name == "Bookmarks" }
      end
    end
    context "music feeds" do
      setup do
        build_music_service
        @feeds = Service.build_music_feeds(@terms, @user.id, nil, true) # We build the music service above so we have to force a cache refresh
      end
      should "only create music feeds" do
        assert @feeds.length > 0
        assert @feeds.all? { |feed| feed.service.service_category.name == "Music" }
      end
    end
    context "news feeds" do
      setup do
        @feeds = Service.build_news_feeds(@terms, @user.id, nil, true) # We build the news service above so we have to force a cache refresh
      end
      should "only create news feeds" do
        assert @feeds.length > 0
        assert @feeds.all? { |feed| feed.service.service_category.name == "News" }
      end
    end
    context "blog feeds" do
      setup do
        @feeds = Service.build_blog_feeds(@terms, @user.id, nil, true) # We build the blog service above so we have to force a cache refresh
      end
      should "only create blog feeds" do
        assert @feeds.length > 0
        assert @feeds.all? { |feed| feed.service.service_category.name == "Blogging" }
      end
    end
    context "search feeds" do
      setup do
        @feeds = Service.build_search_feeds(@terms, @user.id, nil, true) # We build the search service above so we have to force a cache refresh
      end
      should "only create search feeds" do
        assert @feeds.length > 0
        assert @feeds.all? { |feed| feed.service.service_category.name == "Search" }
      end
    end
  end
  
  context "service types" do
    setup do
      build_music_service
    end
    should "get photo services" do
      assert Service.get_photo_tag_services(true).length > 0
      assert Service.get_photo_tag_services.all? { |service| service.service_category.name == "Photos" }
    end
    should "get video services" do
      assert Service.get_video_tag_services(true).length > 0
      assert Service.get_video_tag_services.all? { |service| service.service_category.name == "Videos" }
    end
    should "get bookmark services" do
      assert Service.get_bookmark_tag_services(true).length > 0
      assert Service.get_bookmark_tag_services.all? { |service| service.service_category.name == "Bookmarks" }
    end
    should "get music services" do
      assert Service.get_music_tag_services(true).length > 0
      assert Service.get_music_tag_services.all? { |service| service.service_category.name == "Music" }
    end
    should "get news services" do
      assert Service.get_news_tag_services(true).length > 0
      assert Service.get_news_tag_services.all? { |service| service.service_category.name == "News" }
    end
    should "get blog services" do
      assert Service.get_blog_tag_services(true).length > 0
      assert Service.get_blog_tag_services.all? { |service| service.service_category.name == "Blogging" }
    end
    should "get search services" do
      assert Service.get_search_tag_services(true).length > 0
      assert Service.get_search_tag_services.all? { |service| service.service_category.name == "Search" }
    end
    should "get general services" do
      assert Service.get_general_tag_services(true).length > 0
      assert !Service.get_general_tag_services.any? { |service| service.service_category.name == "Photos" }
      assert !Service.get_general_tag_services.any? { |service| service.service_category.name == "Videos" }
      assert !Service.get_general_tag_services.any? { |service| service.service_category.name == "Bookmarks" }
      assert !Service.get_general_tag_services.any? { |service| service.service_category.name == "Music" }
    end
  end
  
end
