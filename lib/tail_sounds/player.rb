module TailSounds
  class Player
    SOUND_DIR = File.expand_path File.join( APP_ROOT, 'sounds' )
    class SoundNotFound < StandardError
      def initialize( sound_name )
        super "Could not locate '#{sound_name}' in #{Rubygame::Sound.autoload_dirs}"
      end
    end
    
    def initialize()
      begin
        require 'rubygame'
      rescue LoadError
        require 'rubygems'
        require 'rubygame'
      end

      raise "No Mixer found!  Make sure sdl_mixer is installed." unless defined? Rubygame::Sound
      
      Rubygame::Sound.autoload_dirs << SOUND_DIR
      themes = Dir.new(SOUND_DIR).entries.reject { |e| e =~ /[.]/ }
      Rubygame::Sound.autoload_dirs.concat themes.map { |t| File.join SOUND_DIR, t }
      
      @sounds = []
    end
    
    def play( sound_name )
      sound = Rubygame::Sound[sound_name]
      raise SoundNotFound, sound_name if sound.nil?
      sound.play :stop_after => 3, :fade_out => 2
      @sounds << sound
    end

    def playing?
      @sounds.select! &:playing?
      not @sounds.empty?
    end
  end
end
