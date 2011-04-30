module TextToNoise
  class Mapper
    include Logging
    attr_accessor :mappings

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

    def match( expression, &block )
      if expression.kind_of?( Hash ) && expression.size > 1
        expression.each do |k,v|
          match k => v
        end
      else
        debug "Creating map for #{expression.inspect}"
        mappings << mapping = Mapping.new( expression, &block )
        mapping
      end
    end
    alias_method :map, :match
  end
end
