module TailSounds
  class LineToSoundMapper
    attr_accessor :player
    
    def initialize( player=Player.new )
      @player = player
    end
    
    def dispatch( line )
      case line
      when /cricket/
        player.play( "cricket.wav" )
      end
    end
  end
end
