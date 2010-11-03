require 'rubygems'
require 'rake'

# RSpec
require 'rspec/core/rake_task'


desc "Run all specs"
task :spec => ["spec:unit"]

desc "Run unit specs"
RSpec::Core::RakeTask.new('spec:unit') do |t|
  t.rspec_opts = ['--colour --format progress']
  t.pattern = 'spec/*_spec.rb'
end

task :default => :spec

# For Cron
desc "Adds-up new NASA IOFTD Metadata"
task :cron do

end

