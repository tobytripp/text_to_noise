module TextToNoise
  class Mapping
    include Logging
    attr_accessor :targets
    
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

    def to( sound_or_sounds )
      if sound_or_sounds.is_a? Array
        sounds = sound_or_sounds
      else
        sounds = [sound_or_sounds]
      end
      
      sounds.each do |sound|
        s = sound
        s += ".wav" unless sound =~ /.wav$/
        self.targets << Proc.new { TextToNoise.player.play s }
      end
    end

    def call()
      debug "Calling '#{@regex.inspect}' target..."
      target.call
    end

    def targets() @targets ||= []; end
    def target()
      @i = -1 unless @i
      @i = (@i + 1) % targets.size
      self.targets[@i]
    end
  end
end
