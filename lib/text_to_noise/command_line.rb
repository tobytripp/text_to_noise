require 'text_to_noise/logging'

module TextToNoise
  class CommandLine
    include Logging
    attr_reader :options, :mapping

    DEFAULT_FILE_DELAY = 100
    
    def initialize( options={} )
      @options = {
        :input  =>  $stdin
      }.merge options

      raise ArgumentError, "No configuration file provided." unless @options[:config]
      
      @mapping = Mapper.parse File.read( @options[:config] )
      TextToNoise.player = self.player
      TextToNoise.throttle_delay = @options[:throttle] if @options[:throttle]
      TextToNoise.throttle_delay = @options[:throttle] || DEFAULT_FILE_DELAY if @options[:input] != $stdin
      TextToNoise.logger.level = Logger::DEBUG if @options[:debug]
    rescue Errno::ENOENT => e
      raise ArgumentError, "Could not locate configuration file: '#{@options[:config]}'"
    end
    
    def run
      LogReader.new( options[:input], mapping ).call
      info "Input processing complete.  Waiting for playback to finish..."
      while TextToNoise.player.playing?
        sleep 1
      end
    end

    def player
      @options[:mute] ? MutePlayer.new : Player.new
    end
  end
end
