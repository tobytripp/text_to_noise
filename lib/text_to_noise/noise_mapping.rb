# -*- coding: utf-8 -*-
module TextToNoise
  class NoiseMapping
    include Logging
    attr_accessor :targets, :matcher_conditions
    
    def initialize( expression_or_map, &block )
      debug "Parsing expression: #{expression_or_map.inspect}"

      @matcher_conditions = []
      @regex = nil
      
      case expression_or_map
      when Regexp
        @regex = expression_or_map
      when Hash
        expression_or_map.each do |k,v|
          case k
          when Regexp
            @regex = k
            self.to v
          else
            self.send k.to_sym, v
          end
        end
      else
        raise ArgumentError, "Unrecognized Mapping configuration: #{expression_or_map.inspect}"
      end

      raise ArgumentError,
      "Bad configuration line.  Missing match expression in \"#{expression_or_map.inspect}\"" if @regex.nil?

      matcher_conditions << block if block_given?
    end

    def ===( other )
      match_data = @regex.match( other )
      !match_data.nil? && play?( match_data )
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
      @matcher_conditions << IterationMappingCondition.new( iteration_count )
      self
    end

    def when( &clause )
      @matcher_conditions << clause
      self
    end
    
    def call()
      debug "Calling '#{@regex.inspect}' target…"
      target.call
    end

    def targets() @targets ||= []; end
    def target()
      @i = -1 unless @i
      @i = (@i + 1) % targets.size
      self.targets[@i]
    end

    private

    def play?( match_data )
      return true if @matcher_conditions.empty?
      @matcher_conditions.any? { |c| c.call match_data }
    end
  end
end
