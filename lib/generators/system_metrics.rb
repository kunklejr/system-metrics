module Auditor
  module Generators
    class Base < Rails::Generators::NamedBase
      def self.source_root
        File.expand_path(File.join(File.dirname(__FILE__), 'system_metrics', generator_name, 'templates'))
      end
    end
  end
end
