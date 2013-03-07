module Scraptacular
  class Group
    attr_accessor :name, :suites

    def initialize(name, &block)
      @name = name
      @suites = []

      instance_eval(&block)
    end

    def run(out)
      out.puts "Group: #{self.name}"

      results = {}

      suites.each do |suite|
        results[suite.name] = suite.run(out)
      end

      results
    end

    def suite(name, options = {}, &block)
      suite = Scraptacular::Suite.new(name, options, &block)
      @suites << suite
      suite
    end
  end
end
