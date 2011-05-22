require 'spec_helper'
module TextToNoise
  describe Router do
    it "reloads its configuration if it has changed"
      
    describe ".parse" do
      let( :mapping ) { double( NoiseMapping, :to => nil ) }

      context "given a nil configuration" do
        it "raises an ArgumentError" do
          lambda {
            Router.parse nil
          }.should raise_error( ArgumentError )
        end
      end

      context "given a blank configuration" do
        it "raises an ArgumentError" do
          lambda {
            Router.parse " \t \n"
          }.should raise_error( ArgumentError )
        end
      end
      
      context "given a single line configuration" do
        let( :config  ) { "match( /brown/ ).to \"blue\"" }

        it "creates a Mapping object for the given configuration line" do
          NoiseMapping.should_receive( :new ).with( /brown/ ).and_return mapping
          Router.parse config
        end

        it "configures the mapping" do
          NoiseMapping.stub!( :new ).with( /brown/ ).and_return mapping
          mapping.should_receive( :to ).with( "blue" )
          
          Router.parse config
        end
      end

      context "given a multiple line configuration" do
        let( :config ) { 'match( /brown/ ).to "blue"; map( /green/ ).to "orange"' }
        before { NoiseMapping.stub!( :new ).and_return mapping }

        it "configures the second mapping in addition to the first" do
          mapping.should_receive( :to ).with "blue"
          mapping.should_receive( :to ).with "orange"
          Router.parse config
        end

        it "stores the mappings" do
          Router.parse( config ).should have( 2 ).mappings
        end
      end

      context "given a hash-style configuration" do
        let( :config ) { "match /brown/ => \"blue\"\n" }

        it "configures the mapping" do
          NoiseMapping.should_receive( :new ).with( /brown/ => "blue" ).and_return mapping
          Router.parse config
        end
      end
    end

    describe "#sound_path" do
      subject { described_class.new }
      before { TextToNoise.player = double( TextToNoise::Player ) }

      it "adds the argument to the player's sound paths" do
        paths = []
        TextToNoise.player.should_receive( :sound_dirs ).and_return paths
        subject.sound_path "foo"
      end
    end

    describe "#dispatch" do
      let( :blue )  { /blue/  }
      let( :green ) { /green/ }
      let( :blue2 ) { /blu/  }
      
      subject { Router.new.tap { |m| m.mappings = [blue, green, blue2] } }
      
      it "iterates over its mappings comparing them to the input with #===" do
        blue.should_receive( :=== ).with( anything )
        green.should_receive( :=== ).with( anything )
        
        subject.dispatch "orange"
      end
      
      it "calls #call on all mappings that matched" do
        blue.should_receive :call
        blue2.should_receive :call
        green.should_not_receive :call
        
        subject.dispatch( "blue" )
      end
    end
  end
end
