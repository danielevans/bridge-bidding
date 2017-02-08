require 'bidding/convention'
require 'bidding/filter'
require 'bidding/filter_set'

module Bidding
  class ConventionBuilder
    attr_accessor :key
    attr_accessor :options
    attr_accessor :block
    attr_accessor :convention
    attr_accessor :filter_set

    def initialize key, options={}, &block
      parent       = options.delete(:parent)

      self.key     = key
      self.options = options
      self.block   = block
    end

    def convention
      @convention ||= Convention.new(key, options)
    end

    def filter_set
      @filter_set ||= FilterSet.new
    end

    def build
      convention.filter_sets << filter_set
      instance_exec &block
      convention
    end

    def high_card_points arg
      point_filter :high_card, arg
    end

    def length_points arg
      point_filter :length, arg
    end

    def short_points type, arg # TODO
      fail NotImplementedError, "ConventionBuilder.short_points is not yet implemented"
    end

    def point_filter type, arg
      options = { type: type }
      case arg
      when Range
        options[:range] = arg
      when Hash
        options[:range] = (arg[:minimum] || 0)..(arg[:maximum] || 50)
      when Fixnum
        options[:range] = arg..arg
      else
        raise ArgumentError, "Unkown argument to create a point filter"
      end
      filter_set << Filter::PointFilter.new(options)
    end

    def balanced expected=true
      filter = Filter.new do |hand, _history|
        lengths = hand.cards_by_suit.values.map(&:length)
        expected == (lengths.count == 4 && lengths.count(2) <= 1 && lengths.all? { |l| l >= 2 })
      end
      filter_set << filter
    end

    def length suit: Bridge::Strain.suits, minimum: 0, maximum: 13
      filter = Filter.new do |hand, _history|
        Array(suit).any? do |suit|
          Array(hand.cards_by_suit[suit]).length >= minimum && Array(hand.cards_by_suit[suit]).length <= maximum
        end
      end
      filter_set << filter
    end

    def bid options={}, &block
      convention.bid_block = block || ->(_hand, _history) { Bridge::Bid.new options[:level], options[:strain] }
    end

    def seat number, &block
      if block
        builder = ConventionBuilder.new key, options, &block
        builder.convention = convention
        builder.filter_set = filter_set.dup
        builder.filter_set << Filter::SeatFilter.new(number)
        builder.build
      else
        filter_set << Filter::SeatFilter.new(number)
      end
    end

    def only_if &block
      filter_set << Filter.new(&block)
    end

    def opening expectation=true
      filter = Filter.new do |_hand, history|
        history.all? &:pass?
      end
      filter_set << filter
    end
  end
end
