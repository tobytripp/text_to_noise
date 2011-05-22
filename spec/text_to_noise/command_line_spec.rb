require 'spec_helper'

module TextToNoise
  describe TextToNoise::CommandLine do
    let( :mapping ) { double( NoiseMapping ) }
    let( :reader  ) { double( LogReader, :call => nil ) }
    
    before :each do
      Router.stub!( :parse ).and_return mapping
      LogReader.stub!( :new ).and_return reader
      File.stub!( :read ).with( "sound_map.rb" ).and_return "config"
    end

    describe "#initialize" do
      it "accepts an options object" do
        CommandLine.new "sound_map.rb", {}
      end
      
      it "throws an error if no config file is given" do
        lambda {
          CommandLine.new
        }.should raise_error( ArgumentError )
      end
      
      it "raises an error if the config file cannot be found" do
        File.stub!( :read ).and_raise Errno::ENOENT
        lambda {
          CommandLine.new "not_found"
        }.should raise_error( ArgumentError )
      end

      context "when given a 'config' option" do
        it "instantiates a NoiseMapping object with the specified configuration" do
          File.should_receive( :read ).with( "sound_map.rb" ).and_return "config"
          Router.should_receive( :parse ).with( "config" )
          
          CommandLine.new "sound_map.rb"
        end
      end

      context "when given the 'mute' option" do
        it "sets the global Player to an instance of MutePlayer" do
          TextToNoise.should_receive( :player= ).with instance_of( MutePlayer )
          CommandLine.new "sound_map.rb", :mute => true
        end
      end

      context "when given the 'throttle' option" do
        it "sets the throttle_delay attribute on TextToNoise" do
          TextToNoise.should_receive( :throttle_delay= ).with 100
          CommandLine.new "sound_map.rb", :throttle => 100
        end
      end

      context "when given a 'file' option" do
        it "sets a default throttle_delay" do
          TextToNoise.should_receive( :throttle_delay= ).with 100
          CommandLine.new "sound_map.rb", :input => "sample.log"
        end
      end
    end

    describe "#run" do
      let( :options ) { Hash[:input, :io] }
      
      subject { CommandLine.new( "sound_map.rb", options ) }

      
      it "creates a new LogReader object" do
        LogReader.should_receive( :new )
        subject.run
      end

      it "passes the contents of the file in :input option to the reader" do
        LogReader.should_receive( :new ).with( :io, anything )
        subject.run      
      end

      it "passes an instance of a NoiseMapping to the LogReader" do
        LogReader.should_receive( :new ).with( anything, mapping )
        subject.run
      end

      it "calls #call on the LogReader" do
        reader.should_receive :call
        subject.run
      end
    end
  end
end
