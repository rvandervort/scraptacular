module Scraptacular


  class Scraper
    attr_reader :name, :page

    def initialize(name, &block)
      @name = name
      @block = block
    end

    def result(&block)
      retval = Scraptacular::Result.new(@page)
      retval.instance_eval(&block)

      retval.send :remove_instance_variable, :@page
      @results << retval
    end

    def run(page)
      @page = page
      @results = []
      instance_eval &@block

      
      @results
    end

    def scrape_links(selector, options = {})
      if options[:with]
        unless scraper = Scraptacular.world.scrapers[options[:with]]
          raise ArgumentError, "scraper #{options[:with]} does not exist"  
        end
      else
        raise ArgumentError, "You must supply a scraper using the :with option"
      end

      retval = []
      agent = Mechanize.new

      page.search(selector).each do |link|
        subpage = agent.get(link.attributes["href"].value)
        retval += [*scraper.run(subpage)]
      end

      retval
    end
  end
end
