module Bidding
  class FilterSet < Array
    def matches? *args
      all? do |filter|
        filter.matches? *args
      end
    end

    def dup
      each_with_object(FilterSet.new) do |element,other|
        other << element
      end
    end
  end
end
