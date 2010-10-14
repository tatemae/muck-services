require File.dirname(__FILE__) + '/../spec_helper'
require 'services_mailer'

class ServicesMailerTest < ActiveSupport::TestCase

  describe "deliver emails" do

    def setup
      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.perform_deliveries = true
      ActionMailer::Base.deliveries = []
      @expected = TMail::Mail.new
      @expected.set_content_type "text", "plain", { "charset" => 'utf-8' }
    end

    it "should send notification feed added email" do
      feed = Factory(:feed)
      response = ServicesMailer.deliver_notification_feed_added(feed)
      ActionMailer::Base.deliveries.should_not be_empty
      email = ActionMailer::Base.deliveries.last
      [GlobalConfig.admin_email].should == email.to
      [MuckEngine.configuration.from_email].should == email.from
    end

    it "should send notification oai endpoint added email" do
      oai_endpoint = Factory(:oai_endpoint)
      response = ServicesMailer.deliver_notification_oai_endpoint_added(oai_endpoint)
      ActionMailer::Base.deliveries.should_not be_empty
      email = ActionMailer::Base.deliveries.last
      [GlobalConfig.admin_email].should == email.to
      [MuckEngine.configuration.from_email].should == email.from
    end
    
  end
end
