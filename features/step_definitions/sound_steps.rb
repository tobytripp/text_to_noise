class MockPlayer
  attr_reader :sounds
  
  def initialize()
    @sounds = []
  end
  
  def play( sound )
    sounds << sound
  end

  def playing?() true; end
end

Before do
  TextToNoise.player = MockPlayer.new
end

Then /^the sound file "([^"]*)" should be played$/ do |sound| #"
  TextToNoise.player.sounds.should include( sound )
end
