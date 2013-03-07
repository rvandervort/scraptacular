require 'spec_helper.rb'

describe Scraptacular::Result do
  let(:page) { stub('Page') }
  let(:result) { described_class.new(page) }

  describe "initialize" do
    it "sets the internal page reference" do
      result.instance_variable_get(:@page).should == page
    end
    
    it "sets the result to an empty hash" do
      result.instance_variable_get(:@result).should == {}
    end
  end

  describe ".merge(other_result, priority = :other)" do
    let(:other_result) { described_class.new(page) }
    
    before :each do
      result.instance_variable_set :@result, {url: "url1", attribute: "test"}
      other_result.instance_variable_set :@result, {url: "url2", attribute2: "test"}
    end

    it "adds values from the other_result to the current result hash" do
      result.merge other_result, :other
      result.to_h.should == {url: "url2", attribute: "test", attribute2: "test"}
    end

    context "priority is self" do
      it "does not overwrite values in the current result wiht those from the other" do
        result.merge other_result, :self
        result.to_h.should == {url: "url1", attribute: "test", attribute2: "test"}
      end
    end
  end

  describe ".method_missing" do
    it "evaluates the method name as a new key in the result hash" do
      result.new_field { "test value" }
      result.to_h.has_key?(:new_field).should be_true
      result.to_h[:new_field].should == "test value"
    end
  end

  describe ".to_h" do
  end
end
