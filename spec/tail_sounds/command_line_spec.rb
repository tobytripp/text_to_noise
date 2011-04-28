require 'spec_helper'

describe TailSounds::CommandLine do
  describe "#initialize" do
    it "accepts an options object" do
      TailSounds::CommandLine.new( {} )
    end

    context "when given a 'config' option" do
      it "instantiates a Mapping object with the specified configuration" do
        TailSounds::Mapping.should_receive( :new ).with( "config_file.rb" )
        
        TailSounds::CommandLine.new config: "config_file.rb"
      end
    end
  end

  describe "#run" do
    let( :options ) { Hash[:input, :io] }
    let( :mapping ) { double( TailSounds::Mapping ) }
    let( :reader  ) { double( TailSounds::LogReader, call: nil ) }
    
    subject { TailSounds::CommandLine.new( options ) }

    before :each do
      TailSounds::Mapping.stub!( :new ).and_return mapping
      TailSounds::LogReader.stub!( :new ).and_return reader
    end
    
    it "creates a new LogReader object" do
      TailSounds::LogReader.should_receive( :new )
      subject.run
    end

    it "passes the value of the :input option to the reader" do
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
