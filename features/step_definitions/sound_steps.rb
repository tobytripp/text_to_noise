Then /^the sound file "([^"]*)" should be played$/ do |sound| #"
  TailSounds.player.sounds.should include( sound )
end
