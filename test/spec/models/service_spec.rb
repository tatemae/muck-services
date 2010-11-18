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

require File.dirname(__FILE__) + '/../spec_helper'

describe Service do

  describe "service instance" do

    it { should belong_to :service_category }
    it { should scope_sorted }
    it { should scope_sorted_id }
    
    describe "named scope" do
      describe "identity_services" do
        before do
          @service = Factory(:service, :use_for => 'identity')
          @service_not = Factory(:service, :use_for => 'not')
        end
        it "should find services that have use_for=='identity_services'" do
          Service.identity_services.should include(@service)
        end
        it "should not find services that where use_for!='identity_services'" do
          Service.identity_services.should_not include(@service_not)
        end
      end
      describe "tag_services" do
        before do
          @service = Factory(:service, :use_for => 'tags')
          @service_not = Factory(:service, :use_for => 'not')
        end
        it "should find services that have use_for=='tags'" do
          Service.tag_services.should include(@service)
        end
        it "should not find services that where use_for!='tags'" do
          Service.tag_services.should_not include(@service_not)
        end
      end
      describe "sorted_id" do
        before do
          Service.delete_all
          @first = Factory(:service)
          @second = Factory(:service)
        end
        it "should sort by 'sort' field" do
          Service.sorted_id[0].should == @first
          Service.sorted_id[1].should == @second
        end
      end
      describe "photo_services" do
        before do
          @service_category = Factory(:service_category, :name => 'Photos')
          @service = Factory(:service, :service_category => @service_category)
          @service_not = Factory(:service)
        end
        it "should find services that have 'Photos' for a service category" do
          Service.photo_services.should include(@service)
        end
        it "should not find services that don't have 'Photos' for a service category" do
          Service.photo_services.should_not include(@service_not)
        end
      end
    end
    
    describe "photos" do
      before do
        service_category = Factory(:service_category, :name => 'Photos')
        @service = Factory(:service, :service_category_id => service_category.id)
      end
      it "should be a photo service" do
        @service.photo?(true).should be_true
      end
    end
    
    describe "videos" do
      before do
        service_category = Factory(:service_category, :name => 'Videos')
        @service = Factory(:service, :service_category_id => service_category.id)
      end
      it "should be a video service" do
        @service.video?(true).should be_true
      end
    end
    
    describe "bookmarks" do
      before do
        service_category = Factory(:service_category, :name => 'Bookmarks')
        @service = Factory(:service, :service_category_id => service_category.id)
      end
      it "should be a bookmark service" do
        @service.bookmark?(true).should be_true
      end
    end
    
    describe "music" do
      before do
        service_category = Factory(:service_category, :name => 'Music')
        @service = Factory(:service, :service_category_id => service_category.id)
      end
      it "should be a music service" do
        @service.music?(true).should be_true
      end
    end
    
    describe "news" do
      before do
        service_category = Factory(:service_category, :name => 'News')
        @service = Factory(:service, :service_category_id => service_category.id)
      end
      it "should be a news service" do
        @service.news?(true).should be_true
      end
    end
    
    describe "blog" do
      before do
        service_category = Factory(:service_category, :name => 'Blogging')
        @service = Factory(:service, :service_category_id => service_category.id)
      end
      it "should be a blog service" do
        @service.blog?(true).should be_true
      end
    end
    
    describe "search" do
      before do
        service_category = Factory(:service_category, :name => 'Search')
        @service = Factory(:service, :service_category_id => service_category.id)
      end
      it "should be a search service" do
        @service.search?(true).should be_true
      end
    end
    
    describe "general" do
      before do
        service_category = Factory(:service_category, :name => 'RSS')
        @service = Factory(:service, :service_category_id => service_category.id)
      end
      it "should be a general service" do
        @service.general?(true).should be_true
      end
    end
    
  end
  
  describe "identity services" do
    it "should generate uri using blog url" do
      service = Factory(:service)
      uris = service.generate_uris('', '', TEST_URI)
      uris.map(&:url).include?(TEST_RSS_URI).should be_true
    end
    it "should generate uri using username" do
      service = Factory(:service, :uri_data_template => TEST_USERNAME_TEMPLATE)
      uris = service.generate_uris('jbasdf', '', '')
      uris.map(&:url).include?(TEST_USERNAME_TEMPLATE.sub('{username}', 'jbasdf')).should be_true
    end
    it "should get twitter uri from username" do
      service = Factory(:service, :uri_data_template => "http://www.twitter.com/{username}")
      uris = service.generate_uris('jbasdf', '', '')
      uris.map(&:url).include?("http://twitter.com/statuses/user_timeline/7219042.rss").should be_true
    end
  end
  
  describe "tag services" do
    before do
      @user = Factory(:user)
      @template = "http://example.com/{tag}.rss"
      @uri_template = "http://example.com/{tag}"
      @service = Factory(:service, :uri_data_template => @template, :uri_template => @uri_template,  :use_for => 'tags')
    end
    it "should generate urls for tag" do
      tag = 'rails'
      uris = Service.generate_tag_uris(tag)
      uris.should include(@template.sub('{tag}', tag))
    end
    it "should set display uri when building a feed" do
      tag = 'identity'
      feeds = Service.build_tag_feeds(tag, @user, nil, true)
      feeds.any?{|feed| feed.display_uri == (@uri_template.sub('{tag}', tag))}.should be_true
    end
    it "should build a feed for every tag service" do
      tag = 'cycling'
      feeds = Service.build_tag_feeds(tag, @user, nil, true)
      feeds.length.should == Service.tag_services.length
      feeds.any?{|feed| feed.uri == (@template.sub('{tag}', tag))}.should be_true
    end
    it "should build a limited number of feeds for tag" do
      tag = 'ruby'
      feeds = Service.build_tag_feeds(tag, @user, [@service.id], true)
      feeds.length.should == 1
      feeds.any?{|feed| feed.uri == (@template.sub('{tag}', tag))}.should be_true
    end
    it "should create a feed for every tag service" do
      tag = 'physics'
      feeds = Service.create_tag_feeds(tag, @user, nil, true)
      feeds.length.should == Service.tag_services.length
      feeds.any?{|feed| feed.uri == (@template.sub('{tag}', tag))}.should be_true
    end
    it "should create a limited number of feeds for tag" do
      tag = 'math'
      feeds = Service.create_tag_feeds(tag, @user, [@service.id], true)
      feeds.length.should == 1
      feeds.any?{|feed| feed.uri.should == (@template.sub('{tag}', tag))}
    end
  end
  
  describe "Create feed from service" do
    before do
      @login = 'jbasdf'
      @password = ''
      @uri_data_template = TEST_USERNAME_TEMPLATE
      @service = Factory(:service, :uri_data_template => @uri_data_template)
      @user = Factory(:user)
    end
    it "should create feed from service" do
      feeds = Service.create_tag_feeds_for_service(@service, '', @login, @password, @user.id)
      feed = feeds[0]
      feed.uri.should == @uri_data_template.sub("{username}", @login)
      feed.login.should == @login
      feed.password.should == @password
      feed.service_id.should == @service.id
    end
    it "should create feed from service even with nil template" do
      feeds = Service.create_tag_feeds_for_service(@service, '', @login, @password, @user.id)
      feed = feeds[0]
      feed.uri.should == @uri_data_template.sub("{username}", @login)
      feed.login.should == @login
      feed.password.should == @password
      feed.service_id.should == @service.id
    end
  end
  
  describe "Find service by uri" do
    before do
      Service.delete_all
    end
    after do
      bootstrap_services
    end
    it "should find service when uri is shorter" do
      foo_service = Factory(:service, :uri => 'http://www.foo.com')
      service = Service.find_service_by_uri('foo.com', true)
      service.should == foo_service
    end
    it "should find service uri is longer" do
      example_service = Factory(:service, :uri => 'http://www.example.com')
      service = Service.find_service_by_uri('http://www.example.com/other_stuff', true)
      service.should == example_service
    end
  end
  
  describe "build" do
    before do
      @terms = "ruby"
      @user = Factory(:user)
    end
    describe "photo feeds" do
      before do
        @feeds = Service.build_photo_feeds(@terms, @user.id)
      end
      it "should only create photo feeds" do
        assert @feeds.length > 0
        @feeds.all? { |feed| feed.service.service_category.name == "Photos" }.should be_true
      end
    end
    describe "video feeds" do
      before do
        @feeds = Service.build_video_feeds(@terms, @user.id)
      end
      it "should only create video feeds" do
        assert @feeds.length > 0
        @feeds.all? { |feed| feed.service.service_category.name == "Videos" }.should be_true
      end
    end
    describe "bookmark feeds" do
      before do
        @feeds = Service.build_bookmark_feeds(@terms, @user.id)
      end
      it "should only create bookmark feeds" do
        assert @feeds.length > 0
        @feeds.all? { |feed| feed.service.service_category.name == "Bookmarks" }.should be_true
      end
    end
    describe "music feeds" do
      before do
        build_music_service
        @feeds = Service.build_music_feeds(@terms, @user.id, nil, true) # We build the music service above so we have to force a cache refresh
      end
      it "should only create music feeds" do
        assert @feeds.length > 0
        @feeds.all? { |feed| feed.service.service_category.name == "Music" }.should be_true
      end
    end
    describe "news feeds" do
      before do
        @feeds = Service.build_news_feeds(@terms, @user.id, nil, true) # We build the news service above so we have to force a cache refresh
      end
      it "should only create news feeds" do
        assert @feeds.length > 0
        @feeds.all? { |feed| feed.service.service_category.name == "News" }.should be_true
      end
    end
    describe "blog feeds" do
      before do
        @feeds = Service.build_blog_feeds(@terms, @user.id, nil, true) # We build the blog service above so we have to force a cache refresh
      end
      it "should only create blog feeds" do
        assert @feeds.length > 0
        @feeds.all? { |feed| feed.service.service_category.name == "Blogging" }.should be_true
      end
    end
    describe "search feeds" do
      before do
        @feeds = Service.build_search_feeds(@terms, @user.id, nil, true) # We build the search service above so we have to force a cache refresh
      end
      it "should only create search feeds" do
        assert @feeds.length > 0
        @feeds.all? { |feed| feed.service.service_category.name == "Search" }.should be_true
      end
    end
  end
  
  describe "service types" do
    before do
      build_music_service
    end
    it "should get photo services" do
      assert Service.get_photo_tag_services(true).length > 0
      Service.get_photo_tag_services.all? { |service| service.service_category.name == "Photos" }.should be_true
    end
    it "should get video services" do
      assert Service.get_video_tag_services(true).length > 0
      Service.get_video_tag_services.all? { |service| service.service_category.name == "Videos" }.should be_true
    end
    it "should get bookmark services" do
      assert Service.get_bookmark_tag_services(true).length > 0
      Service.get_bookmark_tag_services.all? { |service| service.service_category.name == "Bookmarks" }.should be_true
    end
    it "should get music services" do
      assert Service.get_music_tag_services(true).length > 0
      Service.get_music_tag_services.all? { |service| service.service_category.name == "Music" }.should be_true
    end
    it "should get news services" do
      assert Service.get_news_tag_services(true).length > 0
      Service.get_news_tag_services.all? { |service| service.service_category.name == "News" }.should be_true
    end
    it "should get blog services" do
      assert Service.get_blog_tag_services(true).length > 0
      Service.get_blog_tag_services.all? { |service| service.service_category.name == "Blogging" }.should be_true
    end
    it "should get search services" do
      assert Service.get_search_tag_services(true).length > 0
      Service.get_search_tag_services.all? { |service| service.service_category.name == "Search" }.should be_true
    end
    it "should get general services" do
      assert Service.get_general_tag_services(true).length > 0
      Service.get_general_tag_services.any? { |service| service.service_category.name == "Photos" }.should_not be_true
      Service.get_general_tag_services.any? { |service| service.service_category.name == "Videos" }.should_not be_true
      Service.get_general_tag_services.any? { |service| service.service_category.name == "Bookmarks" }.should_not be_true
      Service.get_general_tag_services.any? { |service| service.service_category.name == "Music" }.should_not be_true
    end
  end
  
end
