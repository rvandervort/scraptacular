require 'spec_helper.rb'

describe Scraptacular::URL do
  let(:path) { "http://www.google.com" }

  describe "#initialize" do
    it "raises an argument error if the :with option does not reference a valid scraper" do
      expect { Scraptacular::URL.new(path,{with: :does_not_exist}) }.to raise_error(ArgumentError)
    end
    it "does not raise an argument error if the :with options references a valid scraper" do
      Scraptacular.world.scrapers[:exists] = "nothing interesting"

      expect { Scraptacular::URL.new(path,{with: :exists}) }.not_to raise_error(ArgumentError)
    end

    it "sets the internal @path attribute" do
      described_class.new(path).path.should == path
    end
  end


end
