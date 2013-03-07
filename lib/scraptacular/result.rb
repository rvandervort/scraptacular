module Scraptacular
  class Result
    attr_reader :page

    def initialize(page)
      @page = page
      @result = {}
    end

    def merge(other_result, priority = :other)
      if priority == :other
        @result.merge! other_result.to_h
      else
        @result = other_result.to_h.merge @result
      end
    end

    def method_missing(method_name, *args, &block)
      # field_name { page.search(lskdjfskdf) }
      @result[method_name] = instance_eval(&block)
    end

    def to_h
      @result
    end

    def to_json
      @result.to_json
    end
  end
end
