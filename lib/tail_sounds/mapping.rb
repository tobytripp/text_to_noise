module TailSounds
  class Mapping
    attr_accessor :player
    
    def dispatch( line )
      case line
      when /cricket/
        TailSounds.player.play( "cricket.wav" )
      end
    end
  end
end
