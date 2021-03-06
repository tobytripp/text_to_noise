require 'spec_helper'
require 'stringio'

module TextToNoise
  describe LogReader do
    let( :io ) { StringIO.new "phantasm" }
    let( :mapper ) { double( "LineToSoundMapper", :dispatch => nil ) }

    subject { LogReader.new io, mapper }
    
    describe "#call" do
      it "reads lines from the provided IO object using #gets" do
        io.should_receive( :gets )
        subject.call
      end

      it "calls #dispatch on an instance of LineToSoundMapper with each line" do
        mapper.should_receive( :dispatch ).with "phantasm"
        subject.call
      end

      it "calls TextToNoise.throttle! after each line is processed" do
        TextToNoise.should_receive( :throttle! )
        subject.call
      end
    end
  end
end
