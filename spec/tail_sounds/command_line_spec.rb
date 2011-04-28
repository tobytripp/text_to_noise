require 'spec_helper'

describe TailSounds::CommandLine do
  let( :mapping ) { double( TailSounds::Mapping ) }
  let( :reader  ) { double( TailSounds::LogReader, call: nil ) }
  
  before :each do
    TailSounds::Mapper.stub!( :parse ).and_return mapping
    TailSounds::LogReader.stub!( :new ).and_return reader
    File.stub!( :read ).with( "sound_map.rb" ).and_return "config"
  end

  describe "#initialize" do
    it "accepts an options object" do
      TailSounds::CommandLine.new( {} )
    end

    it "raises an error if the config file cannot be found" do
      File.stub!( :read ).and_raise Errno::ENOENT
      lambda {
        TailSounds::CommandLine.new config: "not_found"
      }.should raise_error( ArgumentError )
    end

    context "when given a 'config' option" do
      it "instantiates a Mapping object with the specified configuration" do
        File.should_receive( :read ).with( "sound_map.rb" ).and_return "config"
        TailSounds::Mapper.should_receive( :parse ).with( "config" )
        
        TailSounds::CommandLine.new config: "sound_map.rb"
      end
    end
  end

  describe "#run" do
    let( :options ) { Hash[:input, :io, :config, "sound_map.rb"] }
    
    subject { TailSounds::CommandLine.new( options ) }

    
    it "creates a new LogReader object" do
      TailSounds::LogReader.should_receive( :new )
      subject.run
    end

    it "passes the contents of the file in :input option to the reader" do
      TailSounds::LogReader.should_receive( :new ).with( :io, anything )
      subject.run      
    end

    it "passes an instance of a TailSounds::Mapping to the LogReader" do
      TailSounds::LogReader.should_receive( :new ).with( anything, mapping )
      subject.run
    end

    it "calls #call on the LogReader" do
      reader.should_receive :call
      subject.run
    end
  end
end
