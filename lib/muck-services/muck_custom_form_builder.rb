module MuckServicesCustomFormBuilder

  def service_select(method, options = {}, html_options = {}, additional_service = nil)
    @services ||= (additional_service ? [additional_service] : []) + Service.find(:all, :order => 'name asc')
    self.menu_select(method, I18n.t('muck.services.choose_service'), @services, options.merge(:prompt => I18n.t('muck.services.select_service_prompt'), :wrapper_id => 'muck_services_services_container'), html_options.merge(:id => 'muck_services_services'))
  end
  
  def muck_services_service_select(method, options = {}, html_options = {}, additional_service = nil)
    @services ||= (additional_service ? [additional_service] : []) + Service.find(:all, :order => 'name asc', :conditions => "services.id IN (#{MuckServices::Services::RSS}, #{MuckServices::Services::OAI})")
    self.menu_select(method, I18n.t('muck.services.type_of_metadata'), @services, options.merge(:prompt => I18n.t('muck.services.type_of_metadata'), :wrapper_id => 'muck_services_services_container'), html_options.merge(:id => 'muck_services_services'))
  end

  # creates a select control with languages specific to muck raker.  Default id is 'muck_services_languages'.  If 'retain' is passed for the class value the value of this
  # control will be written into a cookie with the key 'languages'.
  def muck_services_language_select(method, options = {}, html_options = {}, additional_language = nil)
    @languages ||= (additional_language ? [additional_language] : []) + Language.find(:all, :order => 'name asc', :conditions => 'languages.muck_raker_supported = true')
    self.menu_select(method, I18n.t('muck.engine.choose_language'), @languages, options.merge(:prompt => I18n.t('muck.engine.select_language_prompt'), :wrapper_id => 'muck_services_languages-container'), html_options.merge(:id => 'muck_services_languages'))
  end
  
end