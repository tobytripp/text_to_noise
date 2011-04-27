module TailSounds
  class Player
    SOUND_DIR = File.expand_path File.join( APP_ROOT, 'sounds' )
    class SoundNotFound < StandardError; end
    
    def initialize()
      raise "No Mixer found!  Make sure sdl_mixer is installed." unless defined? Rubygame::Sound
      Rubygame::Sound.autoload_dirs << SOUND_DIR
      themes = Dir.new(SOUND_DIR).entries.reject { |e| e =~ /[.]/ }
      Rubygame::Sound.autoload_dirs.concat themes.map { |t| File.join SOUND_DIR, t }
      @sounds = []
    end
    
    def play( sound_name )
      sound = Rubygame::Sound[sound_name]
      raise SoundNotFound, "Could not locate '#{sound_name}' in #{Rubygame::Sound.autoload_dirs}" if sound.nil?
      sound.play :stop_after => 3, :fade_out => 2
      @sounds << sound
    end

    def playing?
      @sounds.any? &:playing?
    end
  end
end
