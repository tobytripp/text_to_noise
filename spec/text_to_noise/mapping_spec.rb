require 'spec_helper'

describe TextToNoise::Mapping do
  describe "#initialize" do
    it "can accept a Hash" do
      mapping = described_class.new /exp/ => "target"
      mapping.target.should be_a( Proc )
    end

    it "can accept a Proc"
  end

  describe "#===" do
    context "when matching against a regex" do
      subject { described_class.new /green/ }
      
      it "returns true when the input matches its regex" do
        subject.should === "green"
      end
      
      it "returns false when the input does not match its regex" do
        subject.should_not === "blue"
      end
    end

    context "when matching against a Proc" do
      it "passes the match string to the Proc"
    end
  end

  describe "#to" do
    subject { described_class.new /green/ }

    before { TextToNoise.player = double( TextToNoise::Player ) }

    it "sets the target of the mapping to a Proc" do
      subject.to( "bar" )
      subject.target.should be_a( Proc )
    end

    it "sets the target to call Player#play on #call" do
      subject.to( "bar.wav" )
      TextToNoise.player.should_receive( :play ).with "bar.wav"

      subject.target.call
    end

    it "automatically appends .wav, if it's not present" do
      subject.to( "bar" )
      TextToNoise.player.should_receive( :play ).with "bar.wav"

      subject.target.call
    end

    it "can accept a list of target files" do
      subject.to ["foo", "bar", "baz"]
      TextToNoise.player.should_receive( :play ).with "foo.wav"
      TextToNoise.player.should_receive( :play ).with "bar.wav"
      TextToNoise.player.should_receive( :play ).with "baz.wav"
      
      subject.target.call
      subject.target.call
      subject.target.call
    end
  end

  describe "#call" do
    subject do
      described_class.new( /green/ ).tap do |mapping|
        mapping.targets = [Proc.new { "called" }]
      end
    end

    it "calls #call on its target" do
      subject.call.should == "called"
    end
  end
end
