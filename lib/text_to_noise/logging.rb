require 'forwardable'

module TextToNoise
  module Logging
    extend Forwardable
    def_delegators :logger, :warn, :debug, :error, :info
    def logger() TextToNoise.logger; end
  end
end
