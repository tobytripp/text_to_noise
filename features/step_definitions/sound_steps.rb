Then /^the sound file "([^"]*)" should be played$/ do |sound| #"
  TextToNoise.player.sounds.should include( sound )
end
