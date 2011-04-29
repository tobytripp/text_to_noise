module TextToNoise
  class CommandLine
    attr_reader :options, :mapping
    
    def initialize( options={} )
      @options = {
        input:  $stdin,
        config: "sound_map.rb"
      }.merge options
      @mapping = Mapper.parse File.read( @options[:config] )
    rescue Errno::ENOENT => e
      raise ArgumentError, "Could not locate configuration file: '#{@options[:config]}'"
    end
    
    def run
      LogReader.new( options[:input], mapping ).call
      puts "Input processing complete.  Waiting for playback..."
      while TextToNoise.player.playing?
        sleep 1
      end
    end
  end
end
