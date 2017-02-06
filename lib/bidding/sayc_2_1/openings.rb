require 'bridge'
SAYC_2_1.define do
  # opening: true implies requirement that history contains only pass bids
  convention :strong_2_club do
    opening true
    length_points minimum: 22
    balanced true
    bid level: 2, strain: Bridge::Strain::Club
  end

  convention :one_notrump_opening do
    opening true
    high_card_points 15..17
    balanced true
    bid level: 1, strain: Bridge::Strain::NoTrump
  end

  convention :two_notrump_opening do
    opening true
    high_card_points 20..21
    balanced true
    bid level: 2, strain: Bridge::Strain::NoTrump
  end

  convention :three_notrump_opening do
    opening true
    high_card_points 25..27
    balanced true
    bid level: 3, strain: Bridge::Strain::NoTrump
  end

  convention :major_opening do
    opening true
    length suit: Bridge::Strain.majors, minimum: 5
    length_points minimum: 13

    seat 3..4 do
      length_points minimum: 11
    end

    seat 4 do
      only_if do |hand, _history| # rule of 15
        hand.length(Bridge::Strain::Spades) + hand.high_card_points >= 15
      end
    end

    bid do |hand, _history|
      strain = hand.length(Bridge::Strain::Heart) > hand.length(Bridge::Strain::Spade) ? Bridge::Strain::Heart : Bridge::Strain::Spade
      Bridge::Bid.new 1, strain
    end
  end

  convention :minor_opening do
    opening true
    length suit: Bridge::Strain.minors, minimum: 3
    length_points minimum: 13

    seat 3..4 do
      length_points minimum: 11
    end

    seat 4 do
      length_points minimum: 0
      only_if do |hand, _history| # rule of 15
        hand.length(Strain::Spades) + hand.high_card_points >= 15
      end
    end

    bid do |hand, _history|
      strain = if hand.length(Bridge::Strain::Diamond) == hand.length(Bridge::Strain::Club) && hand.length(Bridge::Strain::Diamond) == 3
                 Bridge::Strain::Club
               elsif hand.length(Bridge::Strain::Diamond) >= hand.length(Bridge::Strain::Club)
                 Bridge::Strain::Diamond
               else
                 Bridge::Strain::Club
               end

      Bridge::Bid.new 1, strain
    end
  end

  convention :preempt_opening do # TODO: "good" suits
    opening true
    length_points 7..12

    only_if do |hand, _history|
      (Bridge::Strain.suits).any? do |suit|
        hand.length(suit) >= 6 && hand.strong?(suit) && (suit != Bridge::Strain::Club || hand.length(suit) >= 7)
      end
    end

    bid do |hand, _history|
      strain = Bridge::Strain.suits.select do |suit|
        hand.length(suit) >= 6 && (suit != Bridge::Strain::Club || hand.length(suit) >= 7)
      end.sort_by { |suit| hand.length(suit) }.first
      Bridge::Bid.new (hand.length(strain) - 4), strain
    end
  end
end
