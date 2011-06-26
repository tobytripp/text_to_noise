module TextToNoise::Conditions
  class ThrottledMatchCondition
    attr_accessor :last_played, :throttle_period
    
    def initialize( period=0.25)
      @throttle_period = period # seconds
      @last_played = 0
    end
    
    def play?( match_data=nil )
      if elapsed > throttle_period
        self.last_played = Time.now
        true
      else
        false
      end
    end
    alias_method :call, :play?
    
    def elapsed()
      Time.now.to_f - last_played.to_f
    end
  end
end
