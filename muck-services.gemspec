# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{muck-services}
  s.version = "0.1.41"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Joel Duffin", "Justin Ball"]
  s.date = %q{2010-03-04}
  s.description = %q{This gem contains the rails specific code for dealing with feeds, aggregations and recommendations.  It is meant to work with the muck-raker gem.}
  s.email = %q{justin@tatemae.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    ".gitignore",
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
    "app/views/activity_templates/_entry_comment.html.erb",
    "app/views/activity_templates/_entry_share.html.erb",
    "app/views/admin/feeds/index.html.erb",
    "app/views/admin/oai_endpoints/index.html.erb",
    "app/views/aggregations/_aggregation.html.erb",
    "app/views/aggregations/_data_source.html.erb",
    "app/views/aggregations/_data_sources.html.erb",
    "app/views/aggregations/_feeds.html.erb",
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
    "app/views/feed_previews/new.html.erb",
    "app/views/feed_previews/select_feeds.html.erb",
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
    "app/views/identity_feeds/_available_service_categories.html.erb",
    "app/views/identity_feeds/_form.html.erb",
    "app/views/identity_feeds/_services_for_user.html.erb",
    "app/views/identity_feeds/edit.html.erb",
    "app/views/identity_feeds/index.html.erb",
    "app/views/identity_feeds/new.html.erb",
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
    "app/views/recommendations/real_time.pjs.erb",
    "app/views/recommendations/real_time.xml.builder",
    "app/views/service_templates/_facebook.html.erb",
    "app/views/service_templates/_friendfeed.html.erb",
    "app/views/service_templates/_goodreads.html.erb",
    "app/views/service_templates/_linkedin.html.erb",
    "app/views/service_templates/_netflix.html.erb",
    "app/views/service_templates/_polyvore.html.erb",
    "app/views/service_templates/_zotero_group.html.erb",
    "app/views/services/_edit_service.html.erb",
    "app/views/services/_new_service.html.erb",
    "app/views/services/_summary.html.erb",
    "app/views/services/_view_service.html.erb",
    "app/views/services_mailer/notification_feed_added.text.ar.html.erb",
    "app/views/services_mailer/notification_feed_added.text.ar.plain.erb",
    "app/views/services_mailer/notification_feed_added.text.bg.html.erb",
    "app/views/services_mailer/notification_feed_added.text.bg.plain.erb",
    "app/views/services_mailer/notification_feed_added.text.ca.html.erb",
    "app/views/services_mailer/notification_feed_added.text.ca.plain.erb",
    "app/views/services_mailer/notification_feed_added.text.cs.html.erb",
    "app/views/services_mailer/notification_feed_added.text.cs.plain.erb",
    "app/views/services_mailer/notification_feed_added.text.da.html.erb",
    "app/views/services_mailer/notification_feed_added.text.da.plain.erb",
    "app/views/services_mailer/notification_feed_added.text.de.html.erb",
    "app/views/services_mailer/notification_feed_added.text.de.plain.erb",
    "app/views/services_mailer/notification_feed_added.text.el.html.erb",
    "app/views/services_mailer/notification_feed_added.text.el.plain.erb",
    "app/views/services_mailer/notification_feed_added.text.es.html.erb",
    "app/views/services_mailer/notification_feed_added.text.es.plain.erb",
    "app/views/services_mailer/notification_feed_added.text.et.html.erb",
    "app/views/services_mailer/notification_feed_added.text.et.plain.erb",
    "app/views/services_mailer/notification_feed_added.text.fa.html.erb",
    "app/views/services_mailer/notification_feed_added.text.fa.plain.erb",
    "app/views/services_mailer/notification_feed_added.text.fi.html.erb",
    "app/views/services_mailer/notification_feed_added.text.fi.plain.erb",
    "app/views/services_mailer/notification_feed_added.text.fr.html.erb",
    "app/views/services_mailer/notification_feed_added.text.fr.plain.erb",
    "app/views/services_mailer/notification_feed_added.text.gl.html.erb",
    "app/views/services_mailer/notification_feed_added.text.gl.plain.erb",
    "app/views/services_mailer/notification_feed_added.text.hi.html.erb",
    "app/views/services_mailer/notification_feed_added.text.hi.plain.erb",
    "app/views/services_mailer/notification_feed_added.text.hr.html.erb",
    "app/views/services_mailer/notification_feed_added.text.hr.plain.erb",
    "app/views/services_mailer/notification_feed_added.text.html.erb",
    "app/views/services_mailer/notification_feed_added.text.hu.html.erb",
    "app/views/services_mailer/notification_feed_added.text.hu.plain.erb",
    "app/views/services_mailer/notification_feed_added.text.id.html.erb",
    "app/views/services_mailer/notification_feed_added.text.id.plain.erb",
    "app/views/services_mailer/notification_feed_added.text.it.html.erb",
    "app/views/services_mailer/notification_feed_added.text.it.plain.erb",
    "app/views/services_mailer/notification_feed_added.text.iw.html.erb",
    "app/views/services_mailer/notification_feed_added.text.iw.plain.erb",
    "app/views/services_mailer/notification_feed_added.text.ja.html.erb",
    "app/views/services_mailer/notification_feed_added.text.ja.plain.erb",
    "app/views/services_mailer/notification_feed_added.text.ko.html.erb",
    "app/views/services_mailer/notification_feed_added.text.ko.plain.erb",
    "app/views/services_mailer/notification_feed_added.text.lt.html.erb",
    "app/views/services_mailer/notification_feed_added.text.lt.plain.erb",
    "app/views/services_mailer/notification_feed_added.text.lv.html.erb",
    "app/views/services_mailer/notification_feed_added.text.lv.plain.erb",
    "app/views/services_mailer/notification_feed_added.text.mt.html.erb",
    "app/views/services_mailer/notification_feed_added.text.mt.plain.erb",
    "app/views/services_mailer/notification_feed_added.text.nl.html.erb",
    "app/views/services_mailer/notification_feed_added.text.nl.plain.erb",
    "app/views/services_mailer/notification_feed_added.text.no.html.erb",
    "app/views/services_mailer/notification_feed_added.text.no.plain.erb",
    "app/views/services_mailer/notification_feed_added.text.pl.html.erb",
    "app/views/services_mailer/notification_feed_added.text.pl.plain.erb",
    "app/views/services_mailer/notification_feed_added.text.plain.erb",
    "app/views/services_mailer/notification_feed_added.text.pt-PT.html.erb",
    "app/views/services_mailer/notification_feed_added.text.pt-PT.plain.erb",
    "app/views/services_mailer/notification_feed_added.text.ro.html.erb",
    "app/views/services_mailer/notification_feed_added.text.ro.plain.erb",
    "app/views/services_mailer/notification_feed_added.text.ru.html.erb",
    "app/views/services_mailer/notification_feed_added.text.ru.plain.erb",
    "app/views/services_mailer/notification_feed_added.text.sk.html.erb",
    "app/views/services_mailer/notification_feed_added.text.sk.plain.erb",
    "app/views/services_mailer/notification_feed_added.text.sl.html.erb",
    "app/views/services_mailer/notification_feed_added.text.sl.plain.erb",
    "app/views/services_mailer/notification_feed_added.text.sq.html.erb",
    "app/views/services_mailer/notification_feed_added.text.sq.plain.erb",
    "app/views/services_mailer/notification_feed_added.text.sr.html.erb",
    "app/views/services_mailer/notification_feed_added.text.sr.plain.erb",
    "app/views/services_mailer/notification_feed_added.text.sv.html.erb",
    "app/views/services_mailer/notification_feed_added.text.sv.plain.erb",
    "app/views/services_mailer/notification_feed_added.text.th.html.erb",
    "app/views/services_mailer/notification_feed_added.text.th.plain.erb",
    "app/views/services_mailer/notification_feed_added.text.tl.html.erb",
    "app/views/services_mailer/notification_feed_added.text.tl.plain.erb",
    "app/views/services_mailer/notification_feed_added.text.tr.html.erb",
    "app/views/services_mailer/notification_feed_added.text.tr.plain.erb",
    "app/views/services_mailer/notification_feed_added.text.uk.html.erb",
    "app/views/services_mailer/notification_feed_added.text.uk.plain.erb",
    "app/views/services_mailer/notification_feed_added.text.vi.html.erb",
    "app/views/services_mailer/notification_feed_added.text.vi.plain.erb",
    "app/views/services_mailer/notification_feed_added.text.zh-CN.html.erb",
    "app/views/services_mailer/notification_feed_added.text.zh-CN.plain.erb",
    "app/views/services_mailer/notification_feed_added.text.zh-TW.html.erb",
    "app/views/services_mailer/notification_feed_added.text.zh-TW.plain.erb",
    "app/views/services_mailer/notification_feed_added.text.zh.html.erb",
    "app/views/services_mailer/notification_feed_added.text.zh.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.ar.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.ar.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.bg.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.bg.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.ca.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.ca.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.cs.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.cs.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.da.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.da.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.de.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.de.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.el.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.el.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.es.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.es.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.et.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.et.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.fa.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.fa.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.fi.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.fi.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.fr.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.fr.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.gl.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.gl.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.hi.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.hi.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.hr.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.hr.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.hu.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.hu.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.id.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.id.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.it.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.it.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.iw.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.iw.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.ja.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.ja.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.ko.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.ko.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.lt.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.lt.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.lv.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.lv.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.mt.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.mt.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.nl.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.nl.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.no.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.no.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.pl.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.pl.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.pt-PT.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.pt-PT.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.ro.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.ro.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.ru.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.ru.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.sk.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.sk.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.sl.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.sl.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.sq.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.sq.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.sr.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.sr.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.sv.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.sv.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.th.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.th.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.tl.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.tl.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.tr.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.tr.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.uk.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.uk.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.vi.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.vi.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.zh-CN.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.zh-CN.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.zh-TW.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.zh-TW.plain.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.zh.html.erb",
    "app/views/services_mailer/notification_oai_endpoint_added.text.zh.plain.erb",
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
    "config/muck_services_routes.rb",
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
    "lib/active_record/acts/muck_aggregation_owner.rb",
    "lib/active_record/acts/muck_feed_owner.rb",
    "lib/active_record/acts/muck_feed_parent.rb",
    "lib/active_record/acts/muck_recommendations.rb",
    "lib/active_record/acts/muck_services_comment.rb",
    "lib/active_record/acts/muck_services_share.rb",
    "lib/muck_services.rb",
    "lib/muck_services/exceptions.rb",
    "lib/muck_services/initialize_routes.rb",
    "lib/muck_services/languages.rb",
    "lib/muck_services/muck_custom_form_builder.rb",
    "lib/muck_services/services.rb",
    "lib/muck_services/tasks.rb",
    "locales/ar.yml",
    "locales/bg.yml",
    "locales/ca.yml",
    "locales/cs.yml",
    "locales/da.yml",
    "locales/de.yml",
    "locales/el.yml",
    "locales/en.yml",
    "locales/es.yml",
    "locales/et.yml",
    "locales/fa.yml",
    "locales/fi.yml",
    "locales/fr.yml",
    "locales/gl.yml",
    "locales/hi.yml",
    "locales/hr.yml",
    "locales/hu.yml",
    "locales/id.yml",
    "locales/it.yml",
    "locales/iw.yml",
    "locales/ja.yml",
    "locales/ko.yml",
    "locales/lt.yml",
    "locales/lv.yml",
    "locales/mt.yml",
    "locales/nl.yml",
    "locales/no.yml",
    "locales/pl.yml",
    "locales/pt-PT.yml",
    "locales/ro.yml",
    "locales/ru.yml",
    "locales/sk.yml",
    "locales/sl.yml",
    "locales/sq.yml",
    "locales/sr.yml",
    "locales/sv.yml",
    "locales/th.yml",
    "locales/tl.yml",
    "locales/tr.yml",
    "locales/uk.yml",
    "locales/vi.yml",
    "locales/zh-CN.yml",
    "locales/zh-TW.yml",
    "locales/zh.yml",
    "muck-services.gemspec",
    "public/javascripts/muck_services.js",
    "public/stylesheets/frame.css",
    "public/stylesheets/muck-services.css",
    "rails/init.rb"
  ]
  s.homepage = %q{http://github.com/tatemae/muck-services}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{muck-services}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Feeds, aggregations and services for muck}
  s.test_files = [
    "test/rails_root/app/controllers/application_controller.rb",
    "test/rails_root/app/controllers/default_controller.rb",
    "test/rails_root/app/helpers/application_helper.rb",
    "test/rails_root/app/models/activity.rb",
    "test/rails_root/app/models/comment.rb",
    "test/rails_root/app/models/share.rb",
    "test/rails_root/app/models/user.rb",
    "test/rails_root/app/models/user_session.rb",
    "test/rails_root/config/boot.rb",
    "test/rails_root/config/environment.rb",
    "test/rails_root/config/environments/cucumber.rb",
    "test/rails_root/config/environments/development.rb",
    "test/rails_root/config/environments/production.rb",
    "test/rails_root/config/environments/test.rb",
    "test/rails_root/config/initializers/inflections.rb",
    "test/rails_root/config/initializers/mime_types.rb",
    "test/rails_root/config/initializers/requires.rb",
    "test/rails_root/config/initializers/session_store.rb",
    "test/rails_root/config/routes.rb",
    "test/rails_root/db/migrate/20090320174818_create_muck_permissions_and_roles.rb",
    "test/rails_root/db/migrate/20090327231918_create_users.rb",
    "test/rails_root/db/migrate/20090402033319_add_muck_activities.rb",
    "test/rails_root/db/migrate/20090402234137_create_languages.rb",
    "test/rails_root/db/migrate/20090426041056_create_countries.rb",
    "test/rails_root/db/migrate/20090426041103_create_states.rb",
    "test/rails_root/db/migrate/20090602191243_create_muck_raker.rb",
    "test/rails_root/db/migrate/20090613173314_create_comments.rb",
    "test/rails_root/db/migrate/20090619211125_create_tag_clouds.rb",
    "test/rails_root/db/migrate/20090623181458_add_grain_size_to_entries.rb",
    "test/rails_root/db/migrate/20090623193525_add_grain_size_to_tag_clouds.rb",
    "test/rails_root/db/migrate/20090703175825_denormalize_entries_subjects.rb",
    "test/rails_root/db/migrate/20090704220055_create_slugs.rb",
    "test/rails_root/db/migrate/20090716035935_change_tag_cloud_grain_sizes.rb",
    "test/rails_root/db/migrate/20090717173900_add_contributor_to_feeds.rb",
    "test/rails_root/db/migrate/20090717175825_normalize_entries_subjects.rb",
    "test/rails_root/db/migrate/20090721043213_change_services_title_to_name.rb",
    "test/rails_root/db/migrate/20090721054927_remove_services_not_null_from_feeds.rb",
    "test/rails_root/db/migrate/20090723050510_create_feed_parents.rb",
    "test/rails_root/db/migrate/20090728165716_add_etag_to_feeds.rb",
    "test/rails_root/db/migrate/20090730044139_add_comment_cache.rb",
    "test/rails_root/db/migrate/20090730045848_add_comment_cache_to_entries.rb",
    "test/rails_root/db/migrate/20090730154102_allow_null_user.rb",
    "test/rails_root/db/migrate/20090803185323_create_shares.rb",
    "test/rails_root/db/migrate/20090804184247_add_comment_count_to_shares.rb",
    "test/rails_root/db/migrate/20090804211240_add_entry_id_to_shares.rb",
    "test/rails_root/db/migrate/20090804231857_add_shares_uri_index.rb",
    "test/rails_root/db/migrate/20090818204527_add_activity_indexes.rb",
    "test/rails_root/db/migrate/20090819030523_add_attachable_to_activities.rb",
    "test/rails_root/db/migrate/20090826220530_change_services_sequence_to_sort.rb",
    "test/rails_root/db/migrate/20090826225652_create_identity_feeds.rb",
    "test/rails_root/db/migrate/20090827005105_add_identity_fields_to_services.rb",
    "test/rails_root/db/migrate/20090827015308_create_service_categories.rb",
    "test/rails_root/db/migrate/20090827221502_add_prompt_and_template_to_services.rb",
    "test/rails_root/db/migrate/20090915041650_aggregations_to_polymorphic.rb",
    "test/rails_root/db/migrate/20090922174200_update_oai_endpoints.rb",
    "test/rails_root/db/migrate/20090922231552_add_dates_to_oai_endpoints.rb",
    "test/rails_root/db/migrate/20090923150807_rename_name_in_aggregation.rb",
    "test/rails_root/db/migrate/20090924200750_add_uri_data_template_to_services.rb",
    "test/rails_root/db/migrate/20091006183742_add_feed_count_to_aggregation.rb",
    "test/rails_root/db/migrate/20091022150615_add_uri_key_to_services.rb",
    "test/rails_root/db/migrate/20091115011828_add_aggregations_for_personal_recs.rb",
    "test/rails_root/db/migrate/20091116094447_rename_action_table.rb",
    "test/rails_root/db/migrate/20091118203605_add_default_feed_type_to_aggregation_feed.rb",
    "test/rails_root/db/migrate/20100123035450_create_access_codes.rb",
    "test/rails_root/db/migrate/20100123233654_create_access_code_requests.rb",
    "test/rails_root/db/schema.rb",
    "test/rails_root/features/step_definitions/common_steps.rb",
    "test/rails_root/features/step_definitions/visit_steps.rb",
    "test/rails_root/features/step_definitions/webrat_steps.rb",
    "test/rails_root/features/support/env.rb",
    "test/rails_root/features/support/paths.rb",
    "test/rails_root/public/dispatch.rb",
    "test/rails_root/script/create_project.rb",
    "test/rails_root/test/factories.rb",
    "test/rails_root/test/functional/admin/feeds_controller_test.rb",
    "test/rails_root/test/functional/admin/oai_endpoints_controller_test.rb",
    "test/rails_root/test/functional/aggregation_feeds_controller_test.rb",
    "test/rails_root/test/functional/aggregations_controller_test.rb",
    "test/rails_root/test/functional/feed_previews_controller_test.rb",
    "test/rails_root/test/functional/feeds_controller_test.rb",
    "test/rails_root/test/functional/identity_feeds_controller_test.rb",
    "test/rails_root/test/functional/oai_endpoints_controller_test.rb",
    "test/rails_root/test/functional/topics_controller_test.rb",
    "test/rails_root/test/functional/visits_controller_test.rb",
    "test/rails_root/test/test_helper.rb",
    "test/rails_root/test/unit/aggregation_feed_test.rb",
    "test/rails_root/test/unit/aggregation_test.rb",
    "test/rails_root/test/unit/comment_test.rb",
    "test/rails_root/test/unit/entry_test.rb",
    "test/rails_root/test/unit/feed_parent_test.rb",
    "test/rails_root/test/unit/feed_test.rb",
    "test/rails_root/test/unit/identity_feed_test.rb",
    "test/rails_root/test/unit/oai_endpoint_test.rb",
    "test/rails_root/test/unit/one_test.rb",
    "test/rails_root/test/unit/personal_recommendation_test.rb",
    "test/rails_root/test/unit/recommendation_test.rb",
    "test/rails_root/test/unit/service_category_test.rb",
    "test/rails_root/test/unit/service_test.rb",
    "test/rails_root/test/unit/services_mailer_test.rb",
    "test/rails_root/test/unit/share_test.rb",
    "test/rails_root/test/unit/tag_cloud_test.rb",
    "test/rails_root/test/unit/user_test.rb",
    "test/rails_root/vendor/plugins/jrails/init.rb",
    "test/rails_root/vendor/plugins/jrails/install.rb",
    "test/rails_root/vendor/plugins/jrails/lib/jrails.rb",
    "test/rails_root/vendor/plugins/jrails/rails/init.rb",
    "test/rails_root/vendor/plugins/ssl_requirement/lib/ssl_requirement.rb",
    "test/rails_root/vendor/plugins/ssl_requirement/test/ssl_requirement_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<acts-as-taggable-on>, [">= 0"])
      s.add_runtime_dependency(%q<will_paginate>, [">= 0"])
      s.add_runtime_dependency(%q<httparty>, [">= 0"])
      s.add_runtime_dependency(%q<nokogiri>, [">= 0"])
      s.add_runtime_dependency(%q<muck-feedbag>, [">= 0"])
      s.add_runtime_dependency(%q<river>, [">= 0"])
      s.add_runtime_dependency(%q<overlord>, [">= 0"])
      s.add_runtime_dependency(%q<feedzirra>, [">= 0"])
      s.add_runtime_dependency(%q<muck-engine>, [">= 0"])
      s.add_runtime_dependency(%q<muck-users>, [">= 0"])
      s.add_runtime_dependency(%q<muck-comments>, [">= 0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
    else
      s.add_dependency(%q<acts-as-taggable-on>, [">= 0"])
      s.add_dependency(%q<will_paginate>, [">= 0"])
      s.add_dependency(%q<httparty>, [">= 0"])
      s.add_dependency(%q<nokogiri>, [">= 0"])
      s.add_dependency(%q<muck-feedbag>, [">= 0"])
      s.add_dependency(%q<river>, [">= 0"])
      s.add_dependency(%q<overlord>, [">= 0"])
      s.add_dependency(%q<feedzirra>, [">= 0"])
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
    s.add_dependency(%q<muck-feedbag>, [">= 0"])
    s.add_dependency(%q<river>, [">= 0"])
    s.add_dependency(%q<overlord>, [">= 0"])
    s.add_dependency(%q<feedzirra>, [">= 0"])
    s.add_dependency(%q<muck-engine>, [">= 0"])
    s.add_dependency(%q<muck-users>, [">= 0"])
    s.add_dependency(%q<muck-comments>, [">= 0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
  end
end

