require 'spec_helper.rb'

describe Scraptacular::CommandLine do
  describe ".run" do
    let(:options) { {definition_file: 'def_file', session_file: 'sess_file' } }
    let(:cl) { described_class.new }

    before :each do
      described_class.any_instance.stub(:parse_options)
      cl.instance_variable_set :@options, options
    end

    context "with valid inputs" do
      before :each do
        cl.stub(:validate_file).with('def_file', 'definition file', $stdout).and_return(true)
        cl.stub(:validate_file).with('sess_file', 'session file', $stdout).and_return(true)
      end

      it "tells the Scraptacular.world to run" do
        Scraptacular.world.should_receive(:run).with(options)
        cl.run(options)
      end
    end

    context "with invalid inputs" do
      before :each do
        cl.stub(:validate_file).and_return(false)
      end

      it "tells the Scraptacular.world to run" do
        Scraptacular.world.should_not_receive(:run)
        cl.run(options)
      end

    end


  end
end

