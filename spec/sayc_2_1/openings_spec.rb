require 'spec_helper'
require 'bidding/sayc_2_1'

RSpec.describe SAYC_2_1 do
  let(:subject)  { described_class.new }
  let(:card_str) { "AKQJ.AKQ.AKQ.AQK"  }

  let(:cards) do
    [Bridge::Strain::Spade,Bridge::Strain::Heart,Bridge::Strain::Diamond,Bridge::Strain::Club].zip(card_str.split('.')).map do |(strain,str)|
      str.chars.map { |c| Bridge::Card.for suits: [strain], ranks: [Bridge::Rank[c]] }
    end.flatten
  end

  let(:seat)    { 1 }
  let(:history) { [Bridge::Bid.new]*(seat - 1)  }
  let(:bid)     { subject.bid(hand, history) }

  let(:hand) do
    Bridge::Hand.new cards
  end

  describe "openings" do
    context "with a balanced 25-27 hand" do
      let(:card_str) do
        "AK2.AK2.AK2.AT32"
      end

      it "opens 3 no trump" do
        expect(bid).to eq Bridge::Bid.new(3, Bridge::Strain::NoTrump)
      end

      context "in third seat" do
        let(:seat) { 3 }
        it "opens 3 no trump" do
          expect(bid).to eq Bridge::Bid.new(3, Bridge::Strain::NoTrump)
        end
      end

      context "in fourth seat" do
        let(:seat) { 4 }
        it "opens 3 no trump" do
          expect(bid).to eq Bridge::Bid.new(3, Bridge::Strain::NoTrump)
        end
      end
    end

    context "with a balanced 20-21 hand" do
      let(:card_str) do
        "AK2.A32.AK2.KT32"
      end

      it "opens 2 no trump" do
        expect(bid).to eq Bridge::Bid.new(2, Bridge::Strain::NoTrump)
      end


      context "in third seat" do
        let(:seat) { 4 }
        it "opens 2 no trump" do
          expect(bid).to eq Bridge::Bid.new(2, Bridge::Strain::NoTrump)
        end
      end

      context "in fourth seat" do
        let(:seat) { 4 }
        it "opens 2 no trump" do
          expect(bid).to eq Bridge::Bid.new(2, Bridge::Strain::NoTrump)
        end
      end
    end

    context "with a balanced 15-17 hand" do
      let(:card_str) do
        "A32.A32.A32.AT32"
      end

      it "opens 1 no trump" do
        expect(bid).to eq Bridge::Bid.new(1, Bridge::Strain::NoTrump)
      end

      context "in third seat" do
        let(:seat) { 3 }
        it "opens 3 no trump" do
          expect(bid).to eq Bridge::Bid.new(1, Bridge::Strain::NoTrump)
        end
      end

      context "in fourth seat" do
        let(:seat) { 4 }
        it "opens 1 no trump" do
          expect(bid).to eq Bridge::Bid.new(1, Bridge::Strain::NoTrump)
        end
      end
    end

    context "with a 22+ hcp hand" do
      let(:card_str) do
        "AKQJ.AKQ.AKQ.AKQ"
      end

      it "opens 2 Club" do
        expect(bid).to eq Bridge::Bid.new(2, Bridge::Strain::Club)
      end

      context "in third seat" do
        let(:seat) { 3 }
        it "opens 1 club" do
          expect(bid).to eq Bridge::Bid.new(2, Bridge::Strain::Club)
        end
      end

      context "in fourth seat" do
        let(:seat) { 4 }
        it "opens 2 club" do
          expect(bid).to eq Bridge::Bid.new(2, Bridge::Strain::Club)
        end
      end
    end

    context "with a 13-21 and a 5 card major" do
      let(:card_str) do
        "AKQJT.432.432.A3"
      end

      it "opens 1 of the major" do
        expect(bid).to eq Bridge::Bid.new(1, Bridge::Strain::Spade)
      end

      context "in third seat" do
        let(:seat) { 3 }
        it "opens 1 of the major" do
          expect(bid).to eq Bridge::Bid.new(1, Bridge::Strain::Spade)
        end
      end

      context "in fourth seat" do
        let(:seat) { 4 }
        it "opens 1 of the major" do
          expect(bid).to eq Bridge::Bid.new(1, Bridge::Strain::Spade)
        end

        context "and failing the rule of 15" do
          let(:card_str) do
            ".AKQT9.432.A5432"
          end
          it "passes" do
            expect(bid).to eq Bridge::Bid.new
          end
        end
      end
    end

    context "with a 11-12 and a 5 card major" do
      let(:card_str) do
        "AQJT9.432.432.A3"
      end

      it "passes" do
        expect(bid).to eq Bridge::Bid.new
      end

      context "in third seat" do
        let(:seat) { 3 }
        it "opens 1 of the major" do
          expect(bid).to eq Bridge::Bid.new(1, Bridge::Strain::Spade)
        end
      end

      context "in fourth seat" do
        let(:seat) { 4 }
        it "opens 1 of the major" do
          expect(bid).to eq Bridge::Bid.new(1, Bridge::Strain::Spade)
        end

        context "and failing the rule of 15" do
          let(:card_str) do
            ".AQT98.432.A5432"
          end
          it "passes" do
            expect(bid).to eq Bridge::Bid.new
          end
        end
      end
    end


    context "with a 13-21 and no 5 card major" do
      let(:card_str) do
        "AKQ.432.432.AJ32"
      end

      it "opens 1 of the minor" do
        expect(bid).to eq Bridge::Bid.new(1, Bridge::Strain::Club)
      end

      context "in third seat" do
        let(:seat) { 3 }
        it "opens 1 of the minor" do
          expect(bid).to eq Bridge::Bid.new(1, Bridge::Strain::Club)
        end
      end

      context "in fourth seat" do
        let(:seat) { 4 }
        it "opens 1 of the minor" do
          expect(bid).to eq Bridge::Bid.new(1, Bridge::Strain::Club)
        end

        context "and failing the rule of 15" do
          let(:card_str) do
            ".AK32.5432.A5432"
          end
          it "passes" do
            expect(bid).to eq Bridge::Bid.new
          end
        end
      end
    end


    context "with a 11-12 and no 5 card major" do
      let(:card_str) do
        "AQ98.432.43.AJ32"
      end

      it "passes" do
        expect(bid).to eq Bridge::Bid.new
      end

      context "in third seat" do
        let(:seat) { 3 }
        it "opens 1 of the minor" do
          expect(bid).to eq Bridge::Bid.new(1, Bridge::Strain::Club)
        end
      end

      context "in fourth seat" do
        let(:seat) { 4 }
        it "opens 1 of the minor" do
          expect(bid).to eq Bridge::Bid.new(1, Bridge::Strain::Club)
        end

        context "and failing the rule of 15" do
          let(:card_str) do
            ".AK32.5432.A5432"
          end
          it "passes" do
            expect(bid).to eq Bridge::Bid.new
          end
        end
      end
    end

    context "with a 7-12 and a 6 card strong suit" do
      let(:card_str) do
        "432.432.AKQJT9.4"
      end

      it "opens 2 of the suit" do
        expect(bid).to eq Bridge::Bid.new(2, Bridge::Strain::Diamond)
      end

      context "when the suit is clubs" do
        let(:card_str) do
          "432.432.4.AKQJT9"
        end

        it "passes" do
          expect(bid).to eq Bridge::Bid.new
        end
      end

      context "in third seat" do
        let(:seat) { 3 }
        it "opens 2 of the minor" do
          expect(bid).to eq Bridge::Bid.new(1, Bridge::Strain::Diamond)
        end
      end

      context "in fourth seat" do
        let(:seat) { 4 }

        context "when the suit is spades but the rule of 15 is not satisfied" do
          let(:card_str) do
            "KQT987.432.432.4"
          end
          it "passes" do
            expect(bid).to eq Bridge::Bid.new
          end
        end

        context "when the suit is not spades" do
          it "passes" do
            expect(bid).to eq Bridge::Bid.new
          end
        end
      end
    end

    context "with a 7-12 and a 7 card strong suit" do
      let(:card_str) do
        "432.43.AKJT987.4"
      end

      it "opens 3 of the suit" do
        expect(bid).to eq Bridge::Bid.new(3, Bridge::Strain::Diamond)
      end
    end

    context "with a 7-12 and a 8 card strong suit" do
      let(:card_str) do
        "432.4.AQJT9876.4"
      end

      it "opens 3 of the suit" do
        expect(bid).to eq Bridge::Bid.new(4, Bridge::Strain::Diamond)
      end
    end

    context "with a 7-12 and a 9 card strong minor" do
      let(:card_str) do
        "43.4.AQJT98765.4"
      end

      it "opens 4 of the minor" do
        expect(bid).to eq Bridge::Bid.new(5, Bridge::Strain::Diamond)
      end
    end

    context "with a 7-12 and a 9 card strong major" do
      let(:card_str) do
        "43.AQJT98765.4.4"
      end

      it "opens 4 of the major" do
        expect(bid).to eq Bridge::Bid.new(4, Bridge::Strain::Heart)
      end
    end

    context "with 0 points" do
      let(:card_str) do
        "5432.432.432.432"
      end

      it "passes" do
        expect(bid).to eq Bridge::Bid.new
      end
    end
  end
end
