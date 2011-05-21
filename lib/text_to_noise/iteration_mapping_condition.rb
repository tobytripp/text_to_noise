module TextToNoise
  class IterationMappingCondition
    attr_accessor :count
    
    def initialize( count )
      self.count = count
      @iteration = 0
    end
    
    def play?()
      @iteration += 1
      count == 1 || (@iteration % count == 0)
    end

    def count=( new_count )
      if new_count > 0
        @count = new_count
      else
        @count = 1
      end
    end
  end
end
