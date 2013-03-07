module Scraptacular
  module Core
    module DSL

      # Define a new grouping
      def scrape_group(name, &group_block)
        Scraptacular.world.register_group name, &group_block
      end

      # Define a new scraper
      def scraper(name, &scraper_block)
        Scraptacular.world.register_scraper name, &scraper_block
      end

    end
  end
end

extend Scraptacular::Core::DSL
Module.send :include, Scraptacular::Core::DSL
