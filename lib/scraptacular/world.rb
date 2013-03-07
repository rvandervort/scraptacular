module Scraptacular
  class World
    attr_accessor :groups, :scrapers

    def initialize
      @groups = []
      @scrapers = {}
    end

    def register_group(name, &block)
      group = Scraptacular::Group.new(name, &block)
      @groups << group
      group
    end

    def register_scraper(identifier, &block)
      scraper = Scraptacular::Scraper.new(identifier, &block)
      @scrapers[identifier] = scraper
      scraper
    end

    def reset
      @results = {}
    end

    def run(options, out = $stdout)
      reset

      if options[:group]
        groups_to_run = @groups.select { |g| g.name == options[:group] }
      else
        groups_to_run = @groups
      end

      groups_to_run.each do |group|
        @results[group.name] = group.run(out)
      end

      @results
    end
  end
end
