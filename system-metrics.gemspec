# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'system_metrics/version'
 
Gem::Specification.new do |s|
  s.name        = "system-metrics"
  s.version     = SystemMetrics::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jeff Kunkle"]
  s.homepage    = "https://github.com/nearinfinity/system-metrics"
  s.summary     = "Web interface to Rails 3 performance metrics"
  s.description = "System Metrics is a Rails 3 Engine that provides a clean web interface to the performance metrics instrumented with ActiveSupport::Notifications"
  s.license     = "MIT"

  s.files         = `git ls-files`.split("\n").reject { |path| path =~ /^(Gemfile|.gitignore|Rakefile)/ }
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('rails', '~> 3.0.0')

  s.add_development_dependency('rspec', '2.5.0')
  s.add_development_dependency('sqlite3-ruby', '1.3.3')
  s.add_development_dependency('rdoc', '3.8')
end
