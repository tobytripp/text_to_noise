module TailSounds
  class LogReader
    attr_reader :io
    def initialize( io, mapper=LineToSoundMapper.new )
      @io, @mapper = io, mapper
    end

    def call()
      while line = io.gets
        @mapper.dispatch line
      end
    end
  end
end
