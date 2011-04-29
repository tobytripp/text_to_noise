module TextToNoise
  class Mapper
    include Logging
    attr_accessor :player, :mappings

    def initialize()
      @mappings = []
    end

    def self.parse( config )
      raise ArgumentError, "No configuration given" if config.nil? or config.strip.empty?
      new.tap { |m|
        m.instance_eval config
        m.info "Configured #{m.mappings.size} mappings."
      }
    end

    def dispatch( line )
      debug "Dispatching: #{line.rstrip}"
      matches = mappings.select { |m| m === line }
      debug "#{matches.size} matched mappings"
      matches.map { |m| m.call }
    end

    protected

    def match( expression )
      debug "Creating map for #{expression.inspect}"
      mappings << mapping = Mapping.new( expression )
      mapping
    end
    alias_method :map, :match
  end
end
