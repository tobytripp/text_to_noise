require 'text_to_noise/logging'

module TextToNoise
  class CommandLine
    include Logging
    attr_reader :options, :mapping

    DEFAULT_FILE_DELAY = 100
    
    def initialize( mapping_configurations, options={} )
      @options = {
        :input  =>  $stdin
      }.merge options

      configs = Array === mapping_configurations ? mapping_configurations : [mapping_configurations]

      raise ArgumentError, "No configuration file provided." if configs.empty?
      
      @mapping = Router.parse File.read( configs.first )
      
      TextToNoise.player = self.player
      TextToNoise.throttle_delay = @options[:throttle] if @options[:throttle]
      TextToNoise.throttle_delay = @options[:throttle] || DEFAULT_FILE_DELAY if @options[:input] != $stdin
      TextToNoise.logger.level   = Logger::DEBUG if @options[:debug]
    rescue Errno::ENOENT => e
      raise ArgumentError, "Could not locate configuration file: '#{configs.first}' (#{e})"
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
