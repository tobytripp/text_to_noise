module TextToNoise
  class LogReader
    attr_reader :io
    def initialize( io, mapper )
      @io, @mapper = io, mapper
    end

    def call()
      while line = io.gets
        @mapper.dispatch line
        sleep 0.200 # FIXME: Think of a better way to throttle playback.
      end
    end
  end
end
