module Scraptacular
  class URL
    attr_reader :path, :scraper

    def initialize(path, options = {})
      @path = path

      if options[:with]
        unless @scraper = Scraptacular.world.scrapers[options[:with]]
          raise ArgumentError, "The supplied scraper :#{options[:with]} does not exist"
        end

      end

    end
  end
end
