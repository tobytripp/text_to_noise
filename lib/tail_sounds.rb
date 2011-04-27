begin
  require 'rubygame'
rescue LoadError
  require 'rubygems'
  require 'rubygame'
end

LIB_DIR   = File.dirname File.expand_path( __FILE__ )
APP_ROOT  = File.join LIB_DIR,  '..'
$LOAD_PATH << LIB_DIR

require "tail_sounds/player"
require "tail_sounds/line_to_sound_mapper"
require "tail_sounds/log_reader"
