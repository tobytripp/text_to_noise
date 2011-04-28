module TailSounds
  class CommandLine
    attr_reader :options, :mapping
    
    def initialize( options={} )
      @options = options
      @mapping = Mapping.new options[:config]
    end
    
    def run
      LogReader.new( options[:input], mapping ).call
    end
  end
end
