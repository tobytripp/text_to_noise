module TextToNoise
  class Player
    include Logging
    
    SOUND_DIR = File.expand_path File.join( APP_ROOT, 'sounds' )
    class SoundNotFound < StandardError
      def initialize( sound_name )
        super "Could not locate '#{sound_name}' in #{Rubygame::Sound.autoload_dirs}"
      end
    end
    
    def initialize()
      self.class.load_rubygame
      
      Rubygame::Sound.autoload_dirs << SOUND_DIR
      themes = Dir.new(SOUND_DIR).entries.reject { |e| e =~ /^[.]/ }
      Rubygame::Sound.autoload_dirs.concat themes.map { |t| File.join SOUND_DIR, t }
      
      @sounds = []
    end
    
    def play( sound_name )
      sound = Rubygame::Sound[sound_name]
      raise SoundNotFound, sound_name if sound.nil?

      debug "Playing #{sound_name}"
      sound.play :fade_out => 2
      @sounds << sound

      debug "#{@sounds.size} sounds in queue" if playing?
    end

    def playing?
      @sounds = @sounds.select &:playing?
      not @sounds.empty?
    end

    def sound_dirs()
      Rubygame::Sound.autoload_dirs
    end
    
    def available_sounds()
      Rubygame::Sound.autoload_dirs.map do |dir|
        Dir[ "#{dir}/*.wav" ].map { |f| File.basename f }
      end.flatten
    end

    def self.load_rubygame()
      old_verbose, $VERBOSE = $VERBOSE, nil
      old_stream, stream = $stdout.dup, $stdout

      return if defined? Rubygame::Sound
      
      stream.reopen '/dev/null'
      stream.sync = true
      
      begin
        require 'rubygame'
      rescue LoadError
        require 'rubygems'
        require 'rubygame'
      end
      
      raise "No Mixer found!  Make sure sdl_mixer is installed." unless defined? Rubygame::Sound
    ensure
      $VERBOSE = old_verbose
      stream.reopen(old_stream)
    end
  end
end
