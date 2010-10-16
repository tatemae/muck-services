class ServicesMailer < ActionMailer::Base
  
  def notification_feed_added(feed)
    @feed = feed                
    mail(:to => MuckEngine.configuration.admin_email, :subject => I18n.t('muck.services.new_global_feed', :application_name => MuckEngine.configuration.application_name)) do |format|
      format.html
      format.text
    end
  end

  def notification_oai_endpoint_added(oai_endpoint)
    @oai_endpoint = oai_endpoint
    mail(:to => MuckEngine.configuration.admin_email, :subject => I18n.t('muck.services.new_global_feed', :application_name => MuckEngine.configuration.application_name)) do |format|
      format.html
      format.text
    end
  end
  
end
