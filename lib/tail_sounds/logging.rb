require 'forwardable'

module TailSounds
  module Logging
    extend Forwardable
    def_delegators :logger, :warn, :debug, :error, :info
    def logger() TailSounds.logger; end
  end
end
