module Bidding
  class Filter
    attr_accessor :parameters
    attr_accessor :block
    def initialize params={}, &block
      self.parameters = params
      self.block = block
    end

    def matches? hand, history
      block && block.call(hand, history)
    end

    class SeatFilter < Filter
      attr_accessor :range
      def initialize seat_range
        case seat_range
        when Fixnum
          self.range = seat_range..seat_range
        when Range
          self.range = seat_range
        else
          fail ArgumentError, "Unkown argument to a seat filter"
        end
      end
    end

    class PointFilter < Filter
      attr_accessor :type
      attr_accessor :range

      def initialize parameter
        self.type = parameter[:type] || :high_card
        self.range = parameter[:range]
      end

      def matches? hand, _history
        range.include? points(hand)
      end

      def points hand
        [type,:high_card].uniq.reduce(0) do |total, point_type|
          total + hand.public_send(:"#{point_type}_points")
        end
      end
    end
  end
end
