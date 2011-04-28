LIB_DIR   = File.dirname File.expand_path( __FILE__ )
APP_ROOT  = File.join LIB_DIR,  '..'
$LOAD_PATH << LIB_DIR

Dir["#{LIB_DIR}/tail_sounds/*.rb"].each { |lib|
  lib =~ %r<lib/(.*)\.rb$>
  require $1
}

module TailSounds
  def self.player
    @player ||= Player.new
  end

  def self.player=( player )
    @player = player
  end
end
