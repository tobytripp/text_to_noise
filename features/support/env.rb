require 'aruba/cucumber'
lib = File.expand_path( '../../../lib/', __FILE__ )
$:.unshift lib unless $:.include?( lib )

require 'text_to_noise'

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
  TextToNoise.player = MockPlayer.new
end
