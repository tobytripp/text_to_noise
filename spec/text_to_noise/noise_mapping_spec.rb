require 'spec_helper'

describe TextToNoise::NoiseMapping do

  before do
    TextToNoise.player = double( TextToNoise::Player )
    
    now = Time.now
    times = (0..60).map { |i| now + i }
    Time.stub(:now) { times.shift }
  end
  
  describe "#initialize" do
    it "can accept a Hash" do
      mapping = described_class.new /exp/ => "target"
      mapping.target.should be_a( Proc )
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

    context "throttling" do
      subject { described_class.new( /green/ ) }
      
      it "prevents immediately consecutive matches" do
        now = Time.now
        Time.stub( :now ).and_return now
        should === "green"
        should_not === "green"
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

      it "does not match immediately" do
        subject.should_not === 'green'
      end

      it "only matches on the given iteration" do
        subject.should_not === 'green'
        subject.should_not === 'green'
        subject.should === 'green'
        subject.should_not === 'green'
        subject.should_not === 'green'
      end
    end

    context "when passed the value 1" do
      subject { described_class.new( /green/ ).to( "red" ).every( 1 ) }

      it "matches on every iteration" do
        subject.should === 'green'
        subject.should === 'green'
        subject.should === 'green'
      end
    end

    context "when passed the value 0" do
      subject { described_class.new( /green/ ).to( "red" ).every( 0 ) }

      it "matches on every iteration" do
        subject.should === 'green'
        subject.should === 'green'
        subject.should === 'green'
      end
    end

    context "when passed the value -1" do
      subject do
        described_class.new( /green/ ).to( "red" ).every( 0 )
      end

      it "matches on every iteration" do
        subject.should === 'green'
        subject.should === 'green'
        subject.should === 'green'
      end
    end

    context "when called multiple times" do
      subject do
        described_class.new( /green/ ).to( "red" ).
          every( 3 ).
          every( 5 )
      end

      it "fires when any rule matches" do
        TextToNoise.player.should_receive( :play ).exactly( 3 ).times
        8.times { subject.call if subject === "green" }
      end
    end
  end

  describe "#when" do
    let( :player ) { TextToNoise.player }
    
    context "given a Proc that returns true" do
      subject { described_class.new( /blue/ ).to( "green" ).when { true } }
      
      it "will match the given input" do
        subject.should === "blue"
      end
    end
    
    context "given a Proc that returns false" do
      subject { described_class.new( /blue/ ).to( "green" ).when { false } }

      it "does not match the input" do
        subject.should_not === "blue"
      end
    end
  end

  describe "#call" do
    subject do
      described_class.new( /green/ ).tap do |mapping|
        mapping.targets = [ Proc.new { "called" } ]
      end
    end

    it "calls #call on its target" do
      subject.call.should == "called"
    end
  end
end
