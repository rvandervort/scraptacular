require 'mechanize'

class String
  def clear
    self.tr_s("\n\r\t","   ")
  end
end

module Scraptacular 
  class << self
    def [](scraper_identifier)
      world.scrapers[scraper_identifier]
    end

    def agent
      @agent ||= Mechanize.new
    end

    def define_scraper(identifier, &block)
      Scraptacular.world.scrapers[identifier.to_sym] = Scraptacular::Scraper.new(identifier, &block)
    end

    def world
      @world ||= Scraptacular::World.new
    end

    def run(options, out = $stdout)
      world.run(options, out)
    end
  end
end

require 'scraptacular/dsl'
require 'scraptacular/world'
require 'scraptacular/group'
require 'scraptacular/suite'
require 'scraptacular/url'
require 'scraptacular/scraper'
require 'scraptacular/command_line'
require 'scraptacular/result'
