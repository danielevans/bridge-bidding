require 'bidding/filter'

module Bidding
  class Convention # todo: impement dup
    attr_accessor :key
    attr_accessor :tags
    attr_accessor :filter_sets
    attr_accessor :bid_block

    def initialize key, options={}
      self.key = key
      @opening = options.delete(:opening) || false
      self.tags = options.delete(:tags) || []
      self.filter_sets = []
    end

    def matches? hand, history
      Array(self.filter_sets).all? do |filter_set|
        filter_set.matches? hand, history
      end
    end

    def define &block
      DSL::ConventionDSL.define self, &block
      self.freeze!
    end

    def bid hand, history
      instance_exec hand, history, &bid_block
    end

    def inspect
      "<#{self.class.name} #{key}>"
    end
  end
end
