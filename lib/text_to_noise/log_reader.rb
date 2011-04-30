module TextToNoise
  class LogReader
    attr_reader :io
    def initialize( io, mapper )
      @io, @mapper = io, mapper
    end

    def call()
      while line = io.gets
        @mapper.dispatch line
        TextToNoise.throttle!
      end
    end
  end
end
