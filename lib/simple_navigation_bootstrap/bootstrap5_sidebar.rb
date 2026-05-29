# frozen_string_literal: true

module SimpleNavigationBootstrap
  class Bootstrap5Sidebar < SimpleNavigation::Renderer::Base

    include BootstrapBase

    private

      def bootstrap_version
        5
      end

      def navigation_class
        'list-unstyled ps-0'
      end

      def render_item(*)
        SimpleNavigationBootstrap::RenderedItem5Sidebar.new(*).to_s
      end

  end
end
