# -*- coding: utf-8 -*-
module TextToNoise
  class Mapping
    include Logging
    attr_accessor :targets, :matcher_proc
    
    def initialize( expression_or_map, &block )
      case expression_or_map
      when Regexp
        @regex = expression_or_map
      when Hash
        @regex, target = expression_or_map.to_a.flatten
        self.to target
      else
        raise ArgumentError, "Unrecognized Mapping configuration: #{expression_or_map.inspect}"
      end

      @matcher_proc = block if block_given?
      @call_count = 0
      @iteration_count = 1
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
          info "#{self.class.name} : #{@regex.inspect} -> #{sound}"
          TextToNoise.player.play s
        }
      end

      self
    end

    def every( iteration_count )
      @iteration_count = iteration_count if iteration_count > 0
      self
    end
    
    def call()
      debug "Calling '#{@regex.inspect}' target…"
      @call_count += 1
      if @iteration_count == 1 || (@call_count % @iteration_count == 0)
        target.call
      else
        debug "\tSkipping…"
      end
    end

    def targets() @targets ||= []; end
    def target()
      @i = -1 unless @i
      @i = (@i + 1) % targets.size
      self.targets[@i]
    end
  end
end
