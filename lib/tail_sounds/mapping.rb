module TailSounds
  class Mapping
    include Logging
    attr_accessor :target
    
    def initialize( expression_or_map )
      case expression_or_map
      when Regexp
        @regex = expression_or_map
      when Hash
        @regex = expression_or_map.keys.first
        self.to expression_or_map[@regex]
      else
        raise ArgumentError, "Unrecognized Mapping configuration: #{expression_or_map.inspect}"
      end
    end

    def ===( other )
      @regex === other
    end

    def to( sound )
      self.target = Proc.new { TailSounds.player.play sound }
    end

    def call()
      debug "Calling '#{@regex.inspect}' target..."
      target.call
    end
  end
end
