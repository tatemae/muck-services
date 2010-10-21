require 'muck_services/muck_custom_form_builder'
require 'muck_services/services'
require 'muck_services/languages'

require 'nokogiri'
require 'httparty'
require 'feedzirra'

ActionController::Base.send :helper, MuckServicesHelper
ActionController::Base.send :helper, MuckServicesFeedsHelper
ActionController::Base.send :helper, MuckServicesServiceHelper
ActionController::Base.send :helper, MuckServicesAggregationsHelper

ActiveRecord::Base.class_eval { include MuckServices::Exceptions }
ActiveRecord::Base.class_eval { include ActiveRecord::Acts::MuckFeedParent }
ActiveRecord::Base.class_eval { include ActiveRecord::Acts::MuckServicesComment }
ActiveRecord::Base.class_eval { include ActiveRecord::Acts::MuckServicesShare }
ActiveRecord::Base.class_eval { include ActiveRecord::Acts::MuckFeedOwner }
ActiveRecord::Base.class_eval { include ActiveRecord::Acts::MuckAggregationOwner }
ActiveRecord::Base.class_eval { include ActiveRecord::Acts::MuckRecommendations }

I18n.load_path += Dir[ File.join(File.dirname(__FILE__), '..', 'locales', '*.{rb,yml}') ]
MuckEngine.add_muck_admin_nav_item('Feeds', '/admin/feeds')