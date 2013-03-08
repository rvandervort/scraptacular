module Scraptacular
  class Suite
    attr_accessor :default_scraper, :urls, :name

    def initialize(name, options = {}, &block)
      @name = name

      if !options.has_key?(:with)
        raise ArgumentError, "You must supply a default scraper using :with"
      end

      @default_scraper =  Scraptacular.world.scrapers[options[:with]]
      if @default_scraper.nil?
        raise ArgumentError, "The supplied scraper :#{options[:with]} does not exist"
      end

      @urls = []

      instance_eval(&block)
    end

    def run(out)
      out.puts "  Suite: #{self.name}"

      results = []

      urls.each do |url|
        out.puts "   URL: #{url.path}"

        scraper = url.scraper
        scraper ||= default_scraper

        page = Scraptacular.agent.get(url.path)
        results += [*scraper.run(page)]
      end

      results
    end

    def url(url_path, options = {})
      urls << Scraptacular::URL.new(url_path, options)
    end
  end
end
