require 'spec_helper'

module TextToNoise
describe TextToNoise::CommandLine do
  let( :mapping ) { double( Mapping ) }
  let( :reader  ) { double( LogReader, :call => nil ) }
  
  before :each do
    Mapper.stub!( :parse ).and_return mapping
    LogReader.stub!( :new ).and_return reader
    File.stub!( :read ).with( "sound_map.rb" ).and_return "config"
  end

  describe "#initialize" do
    it "accepts an options object" do
      CommandLine.new( {} )
    end

    it "raises an error if the config file cannot be found" do
      File.stub!( :read ).and_raise Errno::ENOENT
      lambda {
        CommandLine.new :config => "not_found"
      }.should raise_error( ArgumentError )
    end

    context "when given a 'config' option" do
      it "instantiates a Mapping object with the specified configuration" do
        File.should_receive( :read ).with( "sound_map.rb" ).and_return "config"
        Mapper.should_receive( :parse ).with( "config" )
        
        CommandLine.new :config => "sound_map.rb"
      end
    end

    context "when given the 'mute' option" do
      it "sets the global Player to an instance of MutePlayer" do
        TextToNoise.should_receive( :player= ).with instance_of( MutePlayer )
        CommandLine.new :mute => true
      end
    end
  end

  describe "#run" do
    let( :options ) { Hash[:input, :io, :config, "sound_map.rb"] }
    
    subject { CommandLine.new( options ) }

    
    it "creates a new LogReader object" do
      LogReader.should_receive( :new )
      subject.run
    end

    it "passes the contents of the file in :input option to the reader" do
      LogReader.should_receive( :new ).with( :io, anything )
      subject.run      
    end

    it "passes an instance of a Mapping to the LogReader" do
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
