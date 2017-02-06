module Bidding
  class FilterSet < Array
    def matches? *args
      all? do |filter|
        filter.matches? *args
      end
    end

    def dup
      map(&:dup)
    end
  end
end
