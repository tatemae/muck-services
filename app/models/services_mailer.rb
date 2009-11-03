class ServicesMailer < ActionMailer::Base
  unloadable
  
  layout 'email_default'
  default_url_options[:host] = GlobalConfig.application_url
 
  def notification_feed_added(feed)
    recipients  GlobalConfig.admin_email
    from        "#{GlobalConfig.from_email_name} <#{GlobalConfig.from_email}>"
    sent_on     Time.now
    subject     I18n.t('muck.services.new_global_feed', :application_name => GlobalConfig.application_name)
    body        :feed => feed,
                :application_name => GlobalConfig.application_name
  end

  def notification_oai_endpoint_added(oai_endpoint)
    recipients  GlobalConfig.admin_email
    from        "#{GlobalConfig.from_email_name} <#{GlobalConfig.from_email}>"
    sent_on     Time.now
    subject     I18n.t('muck.services.new_global_feed', :application_name => GlobalConfig.application_name)
    body        :oai_endpoint => oai_endpoint,
                :application_name => GlobalConfig.application_name
  end
  
end
