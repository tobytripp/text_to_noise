require 'aruba/cucumber'
lib = File.expand_path( '../../../lib/', __FILE__ )
$:.unshift lib unless $:.include?( lib )

require 'tail_sounds'

class MockPlayer
  attr_reader :sounds
  
  def initialize()
    @sounds = []
  end
  
  def play( sound )
    sounds << sound
  end
end

Before do
  TailSounds.player = MockPlayer.new
end
