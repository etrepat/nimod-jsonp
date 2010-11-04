require 'rubygems'
require 'rake'

# RSpec ###########################################
require 'rspec/core/rake_task'

desc "Run all specs"
task :spec => ["spec:unit"]

desc "Run unit specs"
RSpec::Core::RakeTask.new('spec:unit') do |t|
  t.rspec_opts = ['--colour --format progress']
  t.pattern = 'spec/*_spec.rb'
end
###################################################

task :default => :spec

require File.dirname(__FILE__) + '/lib/nimod.rb'

desc "Fetches new images (if any) from image of the day feed"
task :fetch do
  Nimod.fetch_from_feed
end

desc "Cron task -- periodically do things (heroku)"
task :cron do
  # fetch images when invoked
  Rake::Task['fetch']
end