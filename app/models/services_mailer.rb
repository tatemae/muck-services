class ServicesMailer < ActionMailer::Base
  unloadable
  
  layout 'email_default'
  default_url_options[:host] = GlobalConfig.application_url
 
  def notification_feed_added(feed)
    muck_setup_email(GlobalConfig.admin_email)
    subject     I18n.t('muck.services.new_global_feed', :application_name => MuckEngine.configuration.application_name)
    body        :feed => feed,
                :application_name => MuckEngine.configuration.application_name
  end

  def notification_oai_endpoint_added(oai_endpoint)
    muck_setup_email(GlobalConfig.admin_email)
    subject     I18n.t('muck.services.new_global_feed', :application_name => MuckEngine.configuration.application_name)
    body        :oai_endpoint => oai_endpoint,
                :application_name => MuckEngine.configuration.application_name
  end
  
end
