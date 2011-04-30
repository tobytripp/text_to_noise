LIB_DIR   = File.dirname File.expand_path( __FILE__ )
APP_ROOT  = File.join LIB_DIR,  '..'
$LOAD_PATH << LIB_DIR

require 'logger'

Dir["#{LIB_DIR}/text_to_noise/*.rb"].each { |lib|
  lib =~ %r<lib/(.*)\.rb$>
  require $1
}

module TextToNoise
  def self.player
    @player ||= Player.new
  end

  def self.player=( player )
    @player = player
  end

  def self.logger
    @logger ||= Logger.new( STDOUT ).tap { |l| l.level = Logger::INFO }
  end

  def self.logger=( logger )
    @logger = logger
    @logger
  end
end
