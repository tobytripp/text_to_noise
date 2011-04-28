require 'spec_helper'

describe TailSounds::Mapping do
  describe "#initialize" do
    it "can accept a Hash" do
      mapping = described_class.new /exp/ => "target"
      mapping.target.should be_a( Proc )
    end
  end
  
  describe "#===" do
    subject { described_class.new /green/ }
      
    it "returns true when the input matches its regex" do
      subject.should === "green"
    end

    it "returns false when the input does not match its regex" do
      subject.should_not === "blue"
    end
  end

  describe "#to" do
    subject { described_class.new /green/ }

    before { TailSounds.player = double( TailSounds::Player ) }
    
    it "sets the target of the mapping to a Proc" do
      subject.to( "bar" )
      subject.target.should be_a( Proc )
    end

    it "sets the target to call Player#play on #call" do
      subject.to( "bar" )
      TailSounds.player.should_receive( :play ).with "bar"

      subject.target.call
    end
  end

  describe "#call" do
    subject do
      described_class.new( /green/ ).tap do |mapping|
        mapping.target = Proc.new { "called" }
      end
    end

    it "calls #call on its target" do
      subject.call.should == "called"
    end
  end
end
