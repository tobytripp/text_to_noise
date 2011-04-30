module TextToNoise
  class Mapping
    include Logging
    attr_accessor :targets, :matcher_proc
    
    def initialize( expression_or_map, &block )
      case expression_or_map
      when Regexp
        @regex = expression_or_map
      when Hash
        @regex = expression_or_map.keys.first
        self.to expression_or_map[@regex]
      else
        raise ArgumentError, "Unrecognized Mapping configuration: #{expression_or_map.inspect}"
      end

      @matcher_proc = block if block_given?
    end

    def ===( other )
      match_data = @regex.match( other )
      if matcher_proc
        match_data && matcher_proc.call( match_data )
      else
        not match_data.nil?
      end
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
        self.targets << Proc.new {
          info "#{@regex.inspect} -> #{sound}"
          TextToNoise.player.play s
        }
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
