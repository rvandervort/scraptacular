require 'spec_helper.rb'

describe Scraptacular::Scraper do
  let(:name) { :scraper_name }
  let(:block) { Proc.new { @test_val = "Hello" } }
  let(:scraper) { described_class.new(name, &block) }


  describe "initialize" do
    it "sets the internal identifier" do
      scraper.name.should == name 
    end
    it "sets the internal block" do
      scraper.instance_variable_get(:@block).should == block
    end
  end

  describe ".scrape_links(selector, options = {})" do

    let(:sub_result1) { stub('Node', attributes: {"href" => stub('Attribute', value: "url1") }) }
    let(:sub_result2) { stub('Node', attributes: {"href" => stub('Attribute', value: "url2") }) }

    let(:page) { stub('Mechanize::Page') }
    let(:sub_page1) { stub('Mechanize::Page') }
    let(:sub_page2) { stub('Mechanize::Page') }

    let(:sub_scraper) do 
      Scraptacular::define_scraper :exists do
        result do
        end
      end
    end
    before :each do
      sub_scraper
      scraper.instance_variable_set :@page, page
      page.stub(:search).and_return([sub_result1, sub_result2])
      Mechanize.any_instance.stub(:get).with("url1").and_return(sub_page1)
      Mechanize.any_instance.stub(:get).with("url2").and_return(sub_page2)
    end

    it "raises an ArgumentError if no :with parameter was supplied" do
      expect { scraper.scrape_links("a.test_links", {})}.to raise_error(ArgumentError)
    end
    it "raises an ArgumentError if the :with scraper is not registered" do
      expect { scraper.scrape_links("a.test_links", {with: :does_not_exist})}.to raise_error(ArgumentError)
    end
    it "does not raise an ArgumentError if the :with scraper is registered" do
      expect { scraper.scrape_links("a.test_links", {with: :exists})}.not_to raise_error(ArgumentError)
    end
    it "searches the page for links matching the selector" do
      page.should_receive(:search).with("a.test_links")
      scraper.scrape_links "a.test_links", {with: :exists}
    end
    it "retrieves the page contents for each found URL" do
      Mechanize.any_instance.should_receive(:get).with("url1").exactly(1).times
      Mechanize.any_instance.should_receive(:get).with("url2").exactly(1).times

      scraper.scrape_links "a.test_links", {with: :exists}
    end

    it "scrapes the sub-pages using the supplied :with scraper" do
      sub_scraper.should_receive(:run).with(sub_page1).exactly(1).times
      sub_scraper.should_receive(:run).with(sub_page2).exactly(1).times
      scraper.scrape_links "a.test_links", {with: :exists}
    end

    it "returns an array of results" do
      scraper.scrape_links("a.test_links", {with: :exists}).should be_instance_of(Array)
    end
  end

  describe ".run" do
    let(:page) { stub 'Mechanize::Page' }
    it "evalutes the block" do
      expect { scraper.run page }.to change { scraper.instance_variable_get(:@test_val) }.to("Hello")
    end
    it "returns an array of results" do
      scraper.run(page).should be_instance_of(Array)
    end
  end

  describe ".result" do
  end
end
