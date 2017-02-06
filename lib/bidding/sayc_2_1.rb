require 'bidding/base'
class SAYC_2_1 < Bidding::Base
  def self.description
    "Standard American Yellow Card with 2 over 1"
  end

  self.openings = %i{three_notrump_opening two_notrump_opening one_notrump_opening strong_2_club major_opening minor_opening preempt_opening}

end


require 'bidding/sayc_2_1/openings'
