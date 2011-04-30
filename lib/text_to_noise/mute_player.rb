module TextToNoise
  class MutePlayer
    include Logging
    def play( sound_name )
      info "Playing #{sound_name}"
    end

    def playing?() false; end
  end
end
