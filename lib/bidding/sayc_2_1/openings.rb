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

    seat 3 do
      length_points minimum: 11
    end

    seat 4 do
      only_if do |hand, _history| # rule of 15
        hand.length(Bridge::Strain::Spade) + hand.high_card_points >= 15
      end
    end

    # requirements which are not shared with the other seats need to come after the other seats are defined
    length_points minimum: 13
    seat 1..2

    bid do |hand, _history|
      strain = hand.length(Bridge::Strain::Heart) > hand.length(Bridge::Strain::Spade) ? Bridge::Strain::Heart : Bridge::Strain::Spade
      Bridge::Bid.new 1, strain
    end
  end

  convention :minor_opening do
    opening true
    length suit: Bridge::Strain.minors, minimum: 3

    seat 3 do
      length_points minimum: 11
    end

    seat 4 do
      only_if do |hand, _history| # rule of 15
        hand.length(Bridge::Strain::Spade) + hand.high_card_points >= 15
      end
    end

    # requirements which are not shared with the other seats need to come after the other seats are defined
    length_points minimum: 13
    seat 1..2

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

    seat 4 do
      only_if do |hand, _history| # rule of 15
        (hand.length(Bridge::Strain::Spade) + hand.high_card_points >= 15) && hand.length(Bridge::Strain::Spade) >= 6
      end
    end

    only_if do |hand, _history|
      (Bridge::Strain.suits).any? do |suit|
        hand.length(suit) >= 6 && hand.strong?(suit) && (suit != Bridge::Strain::Club || hand.length(suit) >= 7)
      end
    end

    seat 1..3

    bid do |hand, history|
      strain = if history.length == 3 # 4th seat can only preempt in spade
                 Bridge::Strain::Spade
               else
                 Bridge::Strain.suits.select do |suit|
                   hand.length(suit) >= 6 && (suit != Bridge::Strain::Club || hand.length(suit) >= 7)
                 end.sort_by { |suit| hand.length(suit) }.first
               end

      level = (hand.length(strain) - 4)
      level = if Bridge::Strain.majors.include? strain
                [level,4]
              else
                [level,5]
              end.min
      Bridge::Bid.new level, strain
    end
  end
end
