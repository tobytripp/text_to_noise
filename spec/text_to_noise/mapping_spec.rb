require 'spec_helper'

describe TextToNoise::Mapping do

  before { TextToNoise.player = double( TextToNoise::Player ) }
  
  describe "#initialize" do
    it "can accept a Hash" do
      mapping = described_class.new /exp/ => "target"
      mapping.target.should be_a( Proc )
    end

    it "stores a passed block for use in later matching" do
      mapping = described_class.new(  /exp/ => "target" ) { |md| true }
      mapping.matcher_proc.should be_a( Proc )
    end

    it "allows the 'every' option to be specified in the Hash" do
      mapping = described_class.new /exp/ => "target", :every => 3
      mapping.matcher_conditions.should_not be_empty
    end
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
      subject do
        described_class.new( /green (\d+)/ ) { |match_data| match_data[1].to_i > 5 }
      end

      it "matches if the block returns true" do
        should === "green 6"
      end

      it "does not match if the block returns false" do
        should_not === "green 1"
      end
    end
  end

  describe "#to" do
    subject { described_class.new /green/ }

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

    it "returns self" do
      subject.to( "foo" ).should == subject
    end
  end

  describe "#every" do
    context "when passed the value '3'" do
      subject { described_class.new( /green/ ).to( "red" ).every( 3 ) }

      it "does not call the Player immediately" do
        TextToNoise.player.should_not_receive( :play )
        subject.call
      end

      it "only calls the Player on the given iteration" do
        TextToNoise.player.should_receive( :play )
        subject.call
        subject.call
        subject.call
        subject.call
        subject.call
      end
    end

    context "when passed the value 1" do
      subject { described_class.new( /green/ ).to( "red" ).every( 1 ) }

      it "calls the player on every iteration" do
        TextToNoise.player.should_receive( :play ).twice
        subject.call
        subject.call
      end
    end

    context "when passed the value 0" do
      subject { described_class.new( /green/ ).to( "red" ).every( 0 ) }

      it "calls the player on every iteration" do
        TextToNoise.player.should_receive( :play ).exactly(3).times
        subject.call
        subject.call
        subject.call
      end
    end

    context "when passed the value -1" do
      subject { described_class.new( /green/ ).to( "red" ).every( 0 ) }

      it "calls the player on every iteration" do
        TextToNoise.player.should_receive( :play ).twice
        subject.call
        subject.call
      end
    end

    context "when called multiple times" do
      subject do
        described_class.new( /green/ ).to( "red" ).
          every( 3 ).
          every( 5 )
      end

      it "fires when any rule matches" do
        TextToNoise.player.should_receive( :play ).exactly(3).times
        8.times { subject.call }
      end
    end
  end

  describe "#when" do
    context "given a Proc that returns true" do
      it "plays the specified sound"
    end
    
    context "given a Proc that returns false" do
      it "does not play the specified sound"
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
