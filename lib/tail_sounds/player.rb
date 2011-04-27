module TailSounds
  class Player
    SOUND_DIR = File.join APP_ROOT, 'sounds'

    def initialize()
      raise "No Mixer found!  Make sure sdl_mixer is installed." unless defined? Rubygame::Sound
      Rubygame::Sound.autoload_dirs << SOUND_DIR
    end
    
    def play( sound_name )
      sound = Rubygame::Sound[sound_name]
      sound.play :stop_after => 3, :fade_out => 2
    end
  end
end
