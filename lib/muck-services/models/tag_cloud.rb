# include MuckServices::Models::MuckTagCloud
module MuckServices
  module Models
    module MuckTagCloud
      
      extend ActiveSupport::Concern
      
       module ClassMethods
         
         # Get a tag cloud for the given language
         # HACK language_id = 38 is english
         def language_tags(language_id = 38, grain_size = 'all', filter = '')
           cloud = TagCloud.find(:first, :conditions => ["language_id = ? AND grain_size = ? AND filter = ? ", language_id, grain_size, filter.sort.join('/')])
           cloud.nil? ? '' : cloud.tag_list
         end
         
       end
      
    end
  end
end

