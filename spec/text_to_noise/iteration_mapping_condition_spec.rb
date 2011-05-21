require 'spec_helper'

describe TextToNoise::IterationMappingCondition do
  describe "construction" do
    it "accepts a count" do
      described_class.new 4
    end
  end

  context "for value 1" do
    subject { described_class.new 1 }
    
    it "#play? returns true for all calls" do
      3.times do
        subject.play?.should be_true
      end
    end
  end

  context "for value 2" do
    subject { described_class.new 2 }

    it "#play? returns true on every other call" do
      subject.play?.should be_false
      subject.play?.should be_true
      subject.play?.should be_false
      subject.play?.should be_true
    end
  end
end
