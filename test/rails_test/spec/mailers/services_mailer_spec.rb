require File.dirname(__FILE__) + '/../spec_helper'
require 'services_mailer'

describe ServicesMailer do

  describe "deliver emails" do

    before do
      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.perform_deliveries = true
      ActionMailer::Base.deliveries = []
    end

    it "should send notification feed added email" do
      feed = Factory(:feed)
      email = ServicesMailer.notification_feed_added(feed).deliver
      ActionMailer::Base.deliveries.should_not be_empty
      [MuckEngine.configuration.admin_email].should == email.to
      [MuckEngine.configuration.from_email].should == email.from
    end

    it "should send notification oai endpoint added email" do
      oai_endpoint = Factory(:oai_endpoint)
      email = ServicesMailer.notification_oai_endpoint_added(oai_endpoint).deliver
      ActionMailer::Base.deliveries.should_not be_empty
      [MuckEngine.configuration.admin_email].should == email.to
      [MuckEngine.configuration.from_email].should == email.from
    end
    
  end
end
