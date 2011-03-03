# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{muck-services}
  s.version = "3.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Joel Duffin", "Justin Ball"]
  s.date = %q{2011-03-02}
  s.description = %q{This gem contains the rails specific code for dealing with feeds, aggregations and recommendations.  It is meant to work with the muck-raker gem.}
  s.email = %q{justin@tatemae.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    "LICENSE",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "app/controllers/admin/muck/feeds_controller.rb",
    "app/controllers/admin/muck/oai_endpoints_controller.rb",
    "app/controllers/muck/aggregation_feeds_controller.rb",
    "app/controllers/muck/aggregations_controller.rb",
    "app/controllers/muck/entries_controller.rb",
    "app/controllers/muck/feed_previews_controller.rb",
    "app/controllers/muck/feeds_controller.rb",
    "app/controllers/muck/identity_feeds_controller.rb",
    "app/controllers/muck/oai_endpoints_controller.rb",
    "app/controllers/muck/recommendations_controller.rb",
    "app/controllers/muck/topics_controller.rb",
    "app/controllers/muck/visits_controller.rb",
    "app/helpers/muck_services_aggregations_helper.rb",
    "app/helpers/muck_services_feeds_helper.rb",
    "app/helpers/muck_services_helper.rb",
    "app/helpers/muck_services_service_helper.rb",
    "app/models/aggregation.rb",
    "app/models/aggregation_feed.rb",
    "app/models/attention.rb",
    "app/models/attention_type.rb",
    "app/models/click.rb",
    "app/models/entry.rb",
    "app/models/feed.rb",
    "app/models/feed_parent.rb",
    "app/models/identity_feed.rb",
    "app/models/oai_endpoint.rb",
    "app/models/personal_recommendation.rb",
    "app/models/recommendation.rb",
    "app/models/service.rb",
    "app/models/service_category.rb",
    "app/models/services_mailer.rb",
    "app/models/subject.rb",
    "app/models/tag_cloud.rb",
    "app/views/activity_templates/_entry_comment.erb",
    "app/views/activity_templates/_entry_share.erb",
    "app/views/admin/feeds/index.html.erb",
    "app/views/admin/oai_endpoints/index.html.erb",
    "app/views/aggregations/_aggregation.html.erb",
    "app/views/aggregations/_data_source.html.erb",
    "app/views/aggregations/_data_sources.html.erb",
    "app/views/aggregations/_feeds.erb",
    "app/views/aggregations/_preview_form.html.erb",
    "app/views/aggregations/edit.html.erb",
    "app/views/aggregations/index.html.erb",
    "app/views/aggregations/index.iphone.erb",
    "app/views/aggregations/new.html.erb",
    "app/views/aggregations/preview.html.erb",
    "app/views/aggregations/preview.iphone.erb",
    "app/views/aggregations/rss_discovery.html.erb",
    "app/views/aggregations/show.html.erb",
    "app/views/default/_language_list.html.erb",
    "app/views/entries/_related_entry.html.erb",
    "app/views/entries/_result.html.erb",
    "app/views/entries/_result_status.html.erb",
    "app/views/entries/_results.html.erb",
    "app/views/entries/_tag_cloud.html.erb",
    "app/views/entries/browse_by_tags.html.erb",
    "app/views/entries/collections.html.erb",
    "app/views/entries/details.html.erb",
    "app/views/entries/index.html.erb",
    "app/views/entries/search.html.erb",
    "app/views/entries/search.pjs.erb",
    "app/views/entries/search.rdf.builder",
    "app/views/entries/search.rss.builder",
    "app/views/entries/search.xml.builder",
    "app/views/entries/show.html.erb",
    "app/views/entries/track_clicks.html.erb",
    "app/views/feed_previews/new.erb",
    "app/views/feed_previews/select_feeds.erb",
    "app/views/feeds/_entry.html.erb",
    "app/views/feeds/_feed.html.erb",
    "app/views/feeds/_feed_row.html.erb",
    "app/views/feeds/_feed_selection.html.erb",
    "app/views/feeds/_form.html.erb",
    "app/views/feeds/edit.html.erb",
    "app/views/feeds/harvest_now.html.erb",
    "app/views/feeds/index.html.erb",
    "app/views/feeds/new.html.erb",
    "app/views/feeds/new_extended.html.erb",
    "app/views/feeds/new_oai_rss.html.erb",
    "app/views/feeds/show.html.erb",
    "app/views/feeds/unban.html.erb",
    "app/views/identity_feeds/_available_service_categories.erb",
    "app/views/identity_feeds/_form.erb",
    "app/views/identity_feeds/_services_for_user.erb",
    "app/views/identity_feeds/create.erb",
    "app/views/identity_feeds/destroy.erb",
    "app/views/identity_feeds/edit.erb",
    "app/views/identity_feeds/index.erb",
    "app/views/identity_feeds/new.erb",
    "app/views/oai_endpoints/_form.html.erb",
    "app/views/oai_endpoints/_oai_endpoint_row.html.erb",
    "app/views/oai_endpoints/new.html.erb",
    "app/views/oai_endpoints/show.html.erb",
    "app/views/parts/_add_feed.html.erb",
    "app/views/parts/_select_feed.html.erb",
    "app/views/recommendations/get_button.html.erb",
    "app/views/recommendations/greasemonkey.user.js.erb",
    "app/views/recommendations/index.js.erb",
    "app/views/recommendations/index.pjs.erb",
    "app/views/recommendations/index.rss.builder",
    "app/views/recommendations/index.xml.builder",
    "app/views/recommendations/real_time.html.erb",
    "app/views/service_templates/_facebook.erb",
    "app/views/service_templates/_friendfeed.erb",
    "app/views/service_templates/_goodreads.erb",
    "app/views/service_templates/_linkedin.erb",
    "app/views/service_templates/_netflix.erb",
    "app/views/service_templates/_polyvore.erb",
    "app/views/service_templates/_zotero_group.erb",
    "app/views/services/_edit_service.erb",
    "app/views/services/_new_service.erb",
    "app/views/services/_personal_recommendations.erb",
    "app/views/services/_summary.erb",
    "app/views/services/_view_service.erb",
    "app/views/services_mailer/notification_feed_added.html.erb",
    "app/views/services_mailer/notification_feed_added.text.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.erb",
    "app/views/topics/_entry.html.erb",
    "app/views/topics/_feed.html.erb",
    "app/views/topics/_feed_preview.html.erb",
    "app/views/topics/_form.html.erb",
    "app/views/topics/_rss_discover.html.erb",
    "app/views/topics/_simple_entry.html.erb",
    "app/views/topics/new.html.erb",
    "app/views/topics/photos.html.erb",
    "app/views/topics/show.html.erb",
    "app/views/topics/show.opml.builder",
    "app/views/topics/videos.html.erb",
    "app/views/visits/_comments_tool.html.erb",
    "app/views/visits/_frame_scripts.html.erb",
    "app/views/visits/_recommendations.html.erb",
    "app/views/visits/_share_tool.html.erb",
    "app/views/visits/_toolbar.html.erb",
    "app/views/visits/show.html.erb",
    "config/locales/ar.yml",
    "config/locales/bg.yml",
    "config/locales/ca.yml",
    "config/locales/cs.yml",
    "config/locales/da.yml",
    "config/locales/de.yml",
    "config/locales/el.yml",
    "config/locales/en.yml",
    "config/locales/es.yml",
    "config/locales/et.yml",
    "config/locales/fa.yml",
    "config/locales/fi.yml",
    "config/locales/fr.yml",
    "config/locales/gl.yml",
    "config/locales/hi.yml",
    "config/locales/hr.yml",
    "config/locales/hu.yml",
    "config/locales/id.yml",
    "config/locales/it.yml",
    "config/locales/iw.yml",
    "config/locales/ja.yml",
    "config/locales/ko.yml",
    "config/locales/lt.yml",
    "config/locales/lv.yml",
    "config/locales/mt.yml",
    "config/locales/nl.yml",
    "config/locales/no.yml",
    "config/locales/pl.yml",
    "config/locales/pt-PT.yml",
    "config/locales/ro.yml",
    "config/locales/ru.yml",
    "config/locales/sk.yml",
    "config/locales/sl.yml",
    "config/locales/sq.yml",
    "config/locales/sr.yml",
    "config/locales/sv.yml",
    "config/locales/th.yml",
    "config/locales/tl.yml",
    "config/locales/tr.yml",
    "config/locales/uk.yml",
    "config/locales/vi.yml",
    "config/locales/zh-CN.yml",
    "config/locales/zh-TW.yml",
    "config/locales/zh.yml",
    "config/routes.rb",
    "db/bootstrap/attention.yml",
    "db/bootstrap/feeds.yml",
    "db/bootstrap/oai_endpoints.yml",
    "db/bootstrap/service_categories.yml",
    "db/bootstrap/services.yml",
    "db/migrate/20090602191243_create_muck_raker.rb",
    "db/migrate/20090619211125_create_tag_clouds.rb",
    "db/migrate/20090623181458_add_grain_size_to_entries.rb",
    "db/migrate/20090623193525_add_grain_size_to_tag_clouds.rb",
    "db/migrate/20090703175825_denormalize_entries_subjects.rb",
    "db/migrate/20090716035935_change_tag_cloud_grain_sizes.rb",
    "db/migrate/20090717173900_add_contributor_to_feeds.rb",
    "db/migrate/20090717175825_normalize_entries_subjects.rb",
    "db/migrate/20090721043213_change_services_title_to_name.rb",
    "db/migrate/20090721054927_remove_services_not_null_from_feeds.rb",
    "db/migrate/20090723050510_create_feed_parents.rb",
    "db/migrate/20090728165716_add_etag_to_feeds.rb",
    "db/migrate/20090730045848_add_comment_cache_to_entries.rb",
    "db/migrate/20090804211240_add_entry_id_to_shares.rb",
    "db/migrate/20090826220530_change_services_sequence_to_sort.rb",
    "db/migrate/20090826225652_create_identity_feeds.rb",
    "db/migrate/20090827005105_add_identity_fields_to_services.rb",
    "db/migrate/20090827015308_create_service_categories.rb",
    "db/migrate/20090827221502_add_prompt_and_template_to_services.rb",
    "db/migrate/20090915041650_aggregations_to_polymorphic.rb",
    "db/migrate/20090922174200_update_oai_endpoints.rb",
    "db/migrate/20090922231552_add_dates_to_oai_endpoints.rb",
    "db/migrate/20090923150807_rename_name_in_aggregation.rb",
    "db/migrate/20090924200750_add_uri_data_template_to_services.rb",
    "db/migrate/20091006183742_add_feed_count_to_aggregation.rb",
    "db/migrate/20091022150615_add_uri_key_to_services.rb",
    "db/migrate/20091115011828_add_aggregations_for_personal_recs.rb",
    "db/migrate/20091116094447_rename_action_table.rb",
    "db/migrate/20091118203605_add_default_feed_type_to_aggregation_feed.rb",
    "db/migrate/20100903205928_add_dead_entry_fields.rb",
    "lib/muck-services.rb",
    "lib/muck-services/config.rb",
    "lib/muck-services/engine.rb",
    "lib/muck-services/exceptions.rb",
    "lib/muck-services/languages.rb",
    "lib/muck-services/models/aggregation_owner.rb",
    "lib/muck-services/models/feed_owner.rb",
    "lib/muck-services/models/feed_parent.rb",
    "lib/muck-services/models/recommendation.rb",
    "lib/muck-services/models/recommendation_owner.rb",
    "lib/muck-services/models/services_comment.rb",
    "lib/muck-services/models/services_share.rb",
    "lib/muck-services/muck_custom_form_builder.rb",
    "lib/muck-services/services.rb",
    "lib/tasks/muck_services.rake",
    "muck-services.gemspec",
    "public/javascripts/muck_services-src.js",
    "public/javascripts/muck_services.js",
    "public/stylesheets/frame.css",
    "public/stylesheets/muck-services.css"
  ]
  s.homepage = %q{http://github.com/tatemae/muck_services}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.5.2}
  s.summary = %q{Feeds, aggregations and services for muck}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<acts-as-taggable-on>, [">= 0"])
      s.add_runtime_dependency(%q<will_paginate>, [">= 0"])
      s.add_runtime_dependency(%q<httparty>, [">= 0"])
      s.add_runtime_dependency(%q<nokogiri>, [">= 0"])
      s.add_runtime_dependency(%q<hpricot>, [">= 0"])
      s.add_runtime_dependency(%q<muck-feedbag>, [">= 0"])
      s.add_runtime_dependency(%q<river>, [">= 0"])
      s.add_runtime_dependency(%q<overlord>, [">= 0"])
      s.add_runtime_dependency(%q<feedzirra>, [">= 0"])
      s.add_runtime_dependency(%q<muck-raker>, [">= 0"])
      s.add_runtime_dependency(%q<muck-engine>, [">= 0"])
      s.add_runtime_dependency(%q<muck-users>, [">= 0"])
      s.add_runtime_dependency(%q<muck-comments>, [">= 0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
    else
      s.add_dependency(%q<acts-as-taggable-on>, [">= 0"])
      s.add_dependency(%q<will_paginate>, [">= 0"])
      s.add_dependency(%q<httparty>, [">= 0"])
      s.add_dependency(%q<nokogiri>, [">= 0"])
      s.add_dependency(%q<hpricot>, [">= 0"])
      s.add_dependency(%q<muck-feedbag>, [">= 0"])
      s.add_dependency(%q<river>, [">= 0"])
      s.add_dependency(%q<overlord>, [">= 0"])
      s.add_dependency(%q<feedzirra>, [">= 0"])
      s.add_dependency(%q<muck-raker>, [">= 0"])
      s.add_dependency(%q<muck-engine>, [">= 0"])
      s.add_dependency(%q<muck-users>, [">= 0"])
      s.add_dependency(%q<muck-comments>, [">= 0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
    end
  else
    s.add_dependency(%q<acts-as-taggable-on>, [">= 0"])
    s.add_dependency(%q<will_paginate>, [">= 0"])
    s.add_dependency(%q<httparty>, [">= 0"])
    s.add_dependency(%q<nokogiri>, [">= 0"])
    s.add_dependency(%q<hpricot>, [">= 0"])
    s.add_dependency(%q<muck-feedbag>, [">= 0"])
    s.add_dependency(%q<river>, [">= 0"])
    s.add_dependency(%q<overlord>, [">= 0"])
    s.add_dependency(%q<feedzirra>, [">= 0"])
    s.add_dependency(%q<muck-raker>, [">= 0"])
    s.add_dependency(%q<muck-engine>, [">= 0"])
    s.add_dependency(%q<muck-users>, [">= 0"])
    s.add_dependency(%q<muck-comments>, [">= 0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
  end
end

