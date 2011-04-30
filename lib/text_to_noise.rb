LIB_DIR   = File.dirname File.expand_path( __FILE__ )
APP_ROOT  = File.join LIB_DIR,  '..'
$LOAD_PATH << LIB_DIR

require 'logger'

Dir["#{LIB_DIR}/text_to_noise/*.rb"].each { |lib|
  lib =~ %r<lib/(.*)\.rb$>
  require $1
}

module TextToNoise
  include Logging
  
  def player
    @player ||= Player.new
  end

  def player=( player )
    @player = player
  end

  def logger
    @logger ||= Logger.new( STDOUT ).tap { |l| l.level = Logger::INFO }
  end

  def logger=( logger )
    @logger = logger
    @logger
  end

  def throttle_delay=( ms_delay )
    @delay = ms_delay
  end

  def throttle!
    return unless @delay
    debug "waiting #{@delay}ms (#{@delay / 1_000.0}s)"
    sleep @delay / 1_000.0
  end

  extend self
end
