require 'spec_helper.rb'

main = self

methods = [
  :scrape_group,
  :scraper
]

methods.each do |method_name|
  describe "##{method_name}" do
    it "is not added to every object" do
      expect(main).to respond_to(method_name)
      expect(Module.new).to respond_to(method_name)
      expect(Object.new).not_to respond_to(method_name)
    end
  end
end

describe "#scrape_group" do
  let(:world) { Scraptacular::World.new}
  let(:name) { "Test Group" }
  let(:test_block) { Proc.new { } }

  before :each do
    Scraptacular.stub(:world).and_return(world)
  end

  it "registers a new ScrapeGroup object" do
    world.should_receive(:register_group).with(name, &test_block)
    Module.new.scrape_group(name, &test_block)
  end

  it "returns the new group" do
    Module.new.scrape_group(name, &test_block).should be_instance_of(Scraptacular::Group)
  end

end

describe "#scraper" do
end
