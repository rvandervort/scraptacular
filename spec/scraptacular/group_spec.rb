require 'spec_helper.rb'

describe Scraptacular::Group do
  let(:name) { "Test Group" }
  let(:block) { Proc.new { @test_instance_var = 42 } }
  let(:group) { described_class.new(name, &block) }
  
  before :all do
    Scraptacular.world.register_scraper :test_scraper, &Proc.new {}
  end

  describe "initialize" do
    it "sets the group name" do
      group.name.should == name
    end

    it "creates an array of suites" do
      group.suites.should be_instance_of(Array)
    end

    it "executes the block to register the suites" do
      group.instance_variable_get(:@test_instance_var).should == 42
    end
  end

  describe ".run" do
    let(:suite) { Scraptacular::Suite.new "Test Suite", {with: :test_scraper}, &Proc.new {}}

    before :each do
      suite.stub(:run).and_return([1,2,3])
      group.suites << suite
    end

    it "runs each suite" do
      suite.should_receive(:run)
      group.run($stdout)
    end

    it "returns a hash of results for the suites" do
      group.run($stdout).should == {"Test Suite" => [1,2,3]}
    end
  end

  describe ".suite" do
    let(:suite_name) { "Test Suite" }
    let(:suite_options) {{with: :default_scraper } }
    let(:suite_block) { Proc.new {} }

    before :each do
      Scraptacular.world.scrapers.stub(:[]).and_return(true)
    end

    it "creates a new Scraptacular::Suite" do
      group.suites.should_receive(:<<).with(an_instance_of(Scraptacular::Suite))
      group.suite(suite_name, suite_options, &suite_block)
    end

    it "returns the new Suite object" do
      group.suite(suite_name, suite_options, &suite_block).should be_instance_of(Scraptacular::Suite)
    end
  end
end
