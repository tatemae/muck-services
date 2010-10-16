require 'rubygems'
require 'rake'
require 'rake/rdoctask'
require 'rspec/core/rake_task'

desc 'Default: run specs.'
task :default => :spec
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = ["--color", "-c", "-f progress", "-r test/rails_test/spec/spec_helper.rb"]
  t.pattern = 'test/rails_test/spec/**/*_spec.rb'  
end

desc 'Translate this gem'
task :translate do
  file = File.join(File.dirname(__FILE__), 'config', 'locales', 'en.yml')
  system("babelphish -o -y #{file}")
  path = File.join(File.dirname(__FILE__), 'app', 'views', 'services_mailer')
  system("babelphish -o -h #{path} -l en")
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |t|
    #t.libs << 'lib'
    t.libs << 'test/rails_test/lib'
    t.pattern = 'test/rails_test/test/**/*_test.rb'
    t.verbose = true
    t.output_dir = 'coverage'
    t.rcov_opts << '--exclude "gems/*"'
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "muck-services"
    gem.summary = "Feeds, aggregations and services for muck"
    gem.description = "This gem contains the rails specific code for dealing with feeds, aggregations and recommendations.  It is meant to work with the muck-raker gem."
    gem.email = "justin@tatemae.com"
    gem.homepage = "http://github.com/tatemae/muck_services"
    gem.authors = ["Joel Duffin", "Justin Ball"]
    gem.add_dependency "acts-as-taggable-on"
    gem.add_dependency "will_paginate"
    gem.add_dependency "httparty"
    gem.add_dependency "nokogiri"
    gem.add_dependency "hpricot"
    gem.add_dependency "muck-feedbag"
    gem.add_dependency "river"
    gem.add_dependency "overlord"
    gem.add_dependency "feedzirra"
    gem.add_dependency "muck-raker"
    gem.add_dependency "muck-engine"
    gem.add_dependency "muck-users"
    gem.add_dependency "muck-comments"
    gem.add_development_dependency "shoulda"
    gem.rubyforge_project = 'muck-services'
    gem.files.exclude "public/images/service_icons/source/*"
    gem.files.exclude "test/*"
    gem.test_files.exclude 'test/feed_archive/**'
    gem.test_files.exclude 'test/rails_test/public/images/*'
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "muck-services #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
