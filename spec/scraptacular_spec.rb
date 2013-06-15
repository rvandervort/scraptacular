require 'spec_helper.rb'

describe 'Scraptacular' do
  let(:world) { Scraptacular::World.new }

  before :each do
    Scraptacular.stub(:world).and_return(world)
  end

  describe "#run" do
    let(:options) { Hash.new }
    let(:out) { stub }

    it "delegates to the world instance" do
      world.should_receive(:run).with(options, out)
      Scraptacular.run(options, out)
    end
  end
end
