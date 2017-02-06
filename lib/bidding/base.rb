require 'bidding/dsl'

module Bidding
  class Base
    extend DSL

    def self.description
      "Base Bidder"
    end

    def conventions
      self.class.conventions
    end

    def opening? history
      history.all? &:pass?
    end

    def openings
      self.class.openings
    end

    def bid hand, history
      convention = if opening?(history) && openings
                     Array(openings).map { |key| conventions[key] }.find { |c| c.matches?(hand, history) }
                   else
                     conventions.values.find { |c| c.matches?(hand, history) }
                   end

      if convention
        convention.bid hand, history
      else
        Bridge::Bid.new # pass
      end
    end
  end
end
