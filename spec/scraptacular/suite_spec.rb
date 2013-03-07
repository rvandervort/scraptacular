require 'spec_helper.rb'

describe Scraptacular::Suite do
  let(:name) { "Test Suite" }
  let(:block) { Proc.new { @test_var = "HI!"  } }
  let(:scraper) { stub("Scraptacular::Scraper") }
  let(:suite_options) {{with: :some_identifier }}

  let(:suite) { Scraptacular::Suite.new(name, suite_options, &block) }

  before :each do
    Scraptacular.world.scrapers.stub(:[]).with(:some_identifier).and_return(scraper)
    scraper.stub(:run)
  end

  describe "#initialize" do
    context ":with argument" do
      it "sets the default scraper, if supplied" do
        suite.default_scraper.should == scraper
      end

      it "raises an ArgumentError if the with parameter is not supplied" do
        suite_options.delete(:with)
        expect { suite }.to raise_error(ArgumentError)
      end

      it "raises an ArgumentError if the selected scraper is not defined" do
        Scraptacular.world.scrapers.stub(:[]).and_return(nil)
        expect { suite }.to raise_error(ArgumentError)
      end
    end

    it "initializes an @urls attribute as an Array" do
      suite.instance_variable_get(:@urls).should be_instance_of(Array)
    end

    it "executes the passed block" do
      suite.instance_variable_get(:@test_var).should == "HI!"
    end
  end

  describe ".run" do
    let(:url1) { Scraptacular::URL.new("test_url_1") }
    let(:url2) { Scraptacular::URL.new("test_url_2") }
    let(:page1) { stub('Page 1') }
    let(:page2) { stub('Page 2') }

    let(:fake_result) { stub('Scraptacular::Result')}


    before :each do
      suite.urls << url1
      suite.urls << url2

      Mechanize.any_instance.stub(:get).with(url1.path).and_return(page1)
      Mechanize.any_instance.stub(:get).with(url2.path).and_return(page2)

      scraper.stub(:run).and_return(fake_result)
    end

    it "iterates through all of the URLs" do
      Mechanize.any_instance.should_receive(:get).with(url1.path)
      Mechanize.any_instance.should_receive(:get).with(url2.path)

      suite.run($stdout)
    end

    it "uses the URL's scraper, if defined" do
      sc = Scraptacular.world.register_scraper(:url2_scraper, &Proc.new {})
      url2.instance_variable_set :@scraper, sc

      sc.should_receive(:run).with(page2)
      suite.run($stdout)
    end

    it "uses the default scraper if a url-specified scraper is not defined" do
      scraper.should_receive(:run).with(page1).exactly(1).times
      scraper.should_receive(:run).with(page2).exactly(1).times

      suite.run($stdout)
    end

    it "returns an Array of results" do
      suite.run($stdout).should == [fake_result, fake_result]
    end
  end

  describe ".url(path, options = {})" do
    it "appends a new Scraptacular::URL object to the @urls list" do
      suite.urls.should_receive(:<<).with(an_instance_of(Scraptacular::URL))
      suite.url("dummy path", {})
    end
  end
end
