#!/usr/bin/env ruby
require 'rubygame'
include Rubygame

# Stuff that I had to do to get this running:
#
#     brew install sdl sdl_mixer
#     gem install rubygame rsdl

# Let's start by trying to play a random mp3 passed as an argument
mp3 = ARGV.pop
raise "No Mixer found!  Make sure sdl_mixer is installed." unless defined? Sound
APP_ROOT = File.dirname File.expand_path( __FILE__ )

Sound.autoload_dirs << File.join( APP_ROOT, "sounds" )

# http://rubygame.org/wiki/NamedResources_tutorial#Autoloading_Resources
sound = Sound[mp3]
# sound = Sound.load mp3
sound.play :fade_in => 2, :stop_after => 5

while sound.playing?
  sleep 1
end

# Kick Ass!
