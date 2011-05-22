require "spec_helper"

module Rubygame
  class Sound
    class << self
      attr_accessor :autoload_dirs
      
      def []( sound_name )
      end

      def autoload_dirs()
        @autoload_dirs ||= []
      end
    end
  end
end
  
describe TextToNoise::Player do
  describe "construction" do
    it "adds the default folder to the autoload paths" do
      described_class.new
      Rubygame::Sound.autoload_dirs.should include( TextToNoise::Player::SOUND_DIR )
    end
  end

  describe "#sound_dirs" do
    it "delegates to the underlying rubygame attribute" do
      subject.sound_dirs << "bar"
      Rubygame::Sound.autoload_dirs.should include( "bar" )
    end
  end
end
