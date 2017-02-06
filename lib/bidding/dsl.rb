require 'bidding/convention_builder'
require 'pry'
module Bidding
  module DSL
    def openings= tag_list
      @openings = tag_list
    end

    def openings
      @openings
    end

    def define &block
      instance_eval &block
    end

    def conventions
      @conventions ||= {}
    end

    def convention key, options={}, &block
      conventions[key] = ConventionBuilder.new(key, options, &block).build
    end
  end
end
