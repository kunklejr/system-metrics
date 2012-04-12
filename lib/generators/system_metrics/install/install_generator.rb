require 'rails/generators'

module SystemMetrics
  module Generators
    class InstallGenerator < Rails::Generators::Base

      desc "Install System Metrics public assets"

      source_root File.expand_path("../../../../../public", __FILE__)

      def copy_css_files
        directory "stylesheets", "#{assets_path_for_rails_versions}/stylesheets/system_metrics", :recursive => true
      end

      def copy_image_files
        directory "images", "#{assets_path_for_rails_versions}/images/system_metrics", :recursive => true
      end

      private
        def assets_path_for_rails_versions
          ::Rails.version >= "3.1.0" ? "app/assets" : "public"
        end
    end
  end
end
