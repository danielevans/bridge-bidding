require 'spec_helper'
require 'bidding/sayc_2_1'

RSpec.describe SAYC_2_1 do
  let(:subject) { described_class.new }
  let(:cards)   { Bridge::Card.shuffle.sample }
  let(:history) { [] }
  let(:bid)     { subject.bid(hand, history) }

  let(:hand) do
    Bridge::Hand.new cards
  end

  describe "openings" do
    context "with a balanced 25-27 hand" do
      let(:cards) do # All Aces, 3 kings, 6 low
        Bridge::Card.for(ranks: [Bridge::Rank::Ace]) +
          Bridge::Card.for(suits: Bridge::Strain.suits - [Bridge::Strain::Club], ranks: [Bridge::Rank::King]) +
          Bridge::Card.for(suits: [Bridge::Strain::Club], ranks: Bridge::Rank.spot).sample(2) +
          Bridge::Card.for(suits: [Bridge::Strain::Diamond], ranks: Bridge::Rank.spot).sample(2) +
          Bridge::Card.for(suits: [Bridge::Strain::Heart], ranks: Bridge::Rank.spot).sample(2)
      end

      it "opens 3 no trump" do
        expect(bid).to eq Bridge::Bid.new(3, Bridge::Strain::NoTrump)
      end
    end

    context "with a balanced 20-21 hand" do
      let(:cards) do # All Aces, 1 king
        Bridge::Card.for(ranks: [Bridge::Rank::Ace]) +
          Bridge::Card.for(suits: [Bridge::Strain::Spade],   ranks: [Bridge::Rank::King, Bridge::Rank::Jack]) +

          Bridge::Card.for(suits: [Bridge::Strain::Club],    ranks: Bridge::Rank.spot).sample(2) +
          Bridge::Card.for(suits: [Bridge::Strain::Diamond], ranks: Bridge::Rank.spot).sample(2) +
          Bridge::Card.for(suits: [Bridge::Strain::Heart],   ranks: Bridge::Rank.spot).sample(2) +
          Bridge::Card.for(suits: [Bridge::Strain::Spade],   ranks: Bridge::Rank.spot).sample(1)
      end

      it "opens 2 no trump" do
        expect(bid).to eq Bridge::Bid.new(2, Bridge::Strain::NoTrump)
      end
    end

    context "with a balanced 15-17 hand" do
      let(:cards) do # All Aces
        Bridge::Card.for(ranks: [Bridge::Rank::Ace]) +
          Bridge::Card.for(suits: [Bridge::Strain::Club],    ranks: Bridge::Rank.spot).sample(2) +
          Bridge::Card.for(suits: [Bridge::Strain::Diamond], ranks: Bridge::Rank.spot).sample(2) +
          Bridge::Card.for(suits: [Bridge::Strain::Heart],   ranks: Bridge::Rank.spot).sample(2) +
          Bridge::Card.for(suits: [Bridge::Strain::Spade],   ranks: Bridge::Rank.spot).sample(3)
      end

      it "opens 2 no trump" do
        expect(bid).to eq Bridge::Bid.new(1, Bridge::Strain::NoTrump)
      end
    end

    context "with a 22+ hcp hand" do
      let(:cards) do # All Aces
        Bridge::Card.for(ranks: [Bridge::Rank::Ace, Bridge::Rank::King, Bridge::Rank::Queen, Bridge::Rank::Jack]).sample(13)
      end

      it "opens 2 no trump" do
        expect(bid).to eq Bridge::Bid.new(2, Bridge::Strain::Club)
      end
    end

    context "with a 13-21 and a 5 card major" do
      let(:cards) do # All Aces
        Bridge::Card.for(suits: [Bridge::Strain::Spade], ranks: [Bridge::Rank::Ace, Bridge::Rank::Jack]) +
          Bridge::Card.for(suits: Bridge::Strain.suits - [Bridge::Strain::Spade], ranks: [Bridge::Rank::Ace]).sample(2) +
          Bridge::Card.for(suits: [Bridge::Strain::Spade], ranks: Bridge::Rank.spot).sample(3) +
          Bridge::Card.for(suits: Bridge::Strain.minors, ranks: Bridge::Rank.spot).sample(6)
      end

      it "opens 1 of the major" do
        expect(bid).to eq Bridge::Bid.new(1, Bridge::Strain::Spade)
      end
    end

    context "with a 13-21 and no 5 card major" do
      let(:cards) do # All Aces
        Bridge::Card.for(suits: [Bridge::Strain::Club], ranks: Bridge::Rank.honors - [Bridge::Rank::Ten]) +
          Bridge::Card.for(suits: [Bridge::Strain::Diamond], ranks: Bridge::Rank.spot).sample(1) +
          Bridge::Card.for(suits: [Bridge::Strain::Spade], ranks: Bridge::Rank.spot).sample(4) +
          Bridge::Card.for(suits: [Bridge::Strain::Heart], ranks: Bridge::Rank.spot).sample(4)
      end

      it "opens 1 of the minor" do
        expect(bid).to eq Bridge::Bid.new(1, Bridge::Strain::Club)
      end
    end
  end
end
