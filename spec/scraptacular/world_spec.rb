require 'spec_helper.rb'

describe Scraptacular::World do
  let(:world) { described_class.new }
  let(:name) { "Name "}
  let(:block) { Proc.new {} }

  describe ".register_group" do
    it "Creates a new group object" do
      Scraptacular::Group.should_receive(:new)
      world.register_group(name, &block)
    end

    it "adds the group object to the world's known group list" do
      expect { world.register_group(name, &block) }.to change { world.groups.count }.to(1)
    end
  end

  describe ".register_scraper" do
    it "creates a new scraper object" do
      Scraptacular::Scraper.should_receive(:new)
      world.register_scraper(name, &block)
    end

    it "adds the scraper object the world's known scraper list" do
      expect { world.register_scraper(name, &block) }.to change{world.scrapers.count }.to(1)
    end
  end

  describe ".run(options)" do
    let(:group1) { Scraptacular::Group.new "Group 1", &Proc.new {}}
    let(:group2) { Scraptacular::Group.new "Group 2", &Proc.new {}}

    before :all do
      world.groups << group1
      world.groups << group2
    end

    it "runs all groups if :group is not specified" do      
      group1.should_receive(:run)
      group2.should_receive(:run)

      world.run({})
    end

    it "runs only a single group if specified, and exists" do
      group1.should_receive(:run)
      group2.should_not_receive(:run)

      world.run({group: "Group 1"})      
    end

    it "returns a hash of results" do
      p world.run({})

    end
  end
end
