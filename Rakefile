$:.unshift File.expand_path("../lib", __FILE__)

require 'rake'
require 'rdoc/task'
require 'rspec/core/rake_task'
require 'bundler'

Bundler::GemHelper.install_tasks

desc 'Default: run specs'
task :default => :spec

desc "Run specs"
RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = %w(-fs --color)
end

desc "Run specs with RCov"
RSpec::Core::RakeTask.new(:rcov) do |t|
  t.rspec_opts = %w(-fs --color)
  t.rcov = true
  t.rcov_opts = %w(--exclude "spec/*,gems/*")
end

desc 'Generate documentation for the gem.'
RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'System Metrics'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

