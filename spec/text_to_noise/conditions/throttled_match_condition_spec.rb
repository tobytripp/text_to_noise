require 'spec_helper'

describe TextToNoise::Conditions::ThrottledMatchCondition do
  describe "#play?" do
    before :each do
      @now = Time.now
      Time.stub!( :now ).and_return @now
    end

    it "returns true on the first call" do
      subject.play?.should be_true
    end

    it "returns false if called again immediately" do
      subject.play?.should be_true
      subject.play?.should be_false
    end

    it "returns true again after a delay" do
      subject.play?
      Time.stub!( :now ).and_return @now + 500
      subject.play?.should be_true
    end
  end
end
