require 'rubygems'
require 'bundler/setup'

require 'rspec'

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'parser'

describe Parser do

  before(:each) do
    @parser = Parser.new
  end

  describe ".identifier" do
    
    describe "#parse" do

      it "parses identifier simple alphanumeric identifiers" do
        @parser.identifier.parse('foo').should == { :identifier => "foo" }
        @parser.identifier.parse('r1q2').should == { :identifier => "r1q2" }
      end

      it "parses identifiers containing unicode" do
        @parser.identifier.parse('dead\uBEEF').should == { :identifier => "dead\\uBEEF" }
        @parser.identifier.parse('dead\UF00DBEEF').should == { :identifier => "dead\\UF00DBEEF" }
      end

      it "rejects identifiers with a leading non-alpha" do
        expect { @parser.identifier.parse('3cow') }.to raise_error(Parslet::ParseFailed)
        expect { @parser.identifier.parse('\uDEADcow') }.to raise_error(Parslet::ParseFailed)
        expect { @parser.identifier.parse('\UDEADBEEFcow') }.to raise_error(Parslet::ParseFailed)
      end
    end

  end

  describe ".expression" do
    
    describe "#parse" do

      it "parses additive expressions" do
        @parser.expression.parse('1 + 2').should == {:additive=>{:left=>{:decimal=>"1"}, :operator=>"+", :right=>{:decimal=>"2"}}}

      end

    end

  end

  describe ".function_definition" do
    
    describe "#parse" do

      it "parses a simple function" do
        @parser.function_definition.parse('inline void foo(void) { }').should == 
          [{:specifier=>{:keyword=>"inline"}}, {:type=>{:keyword=>"void"}}, {:identifier=>"foo"}, {:type=>{:keyword=>"void"}}, {:body=>"{ }"}]
      end

    end

  end

  describe "#parse" do

    it "parses function prototypes" do
      @parser.parse('const char *foo(int bar, int baz);').should == 
         [{:qualifier=>{:keyword=>"const"}}, {:type=>{:keyword=>"char"}}, {:operator=>"*"}, {:identifier=>"foo"}, {:type=>{:keyword=>"int"}}, {:identifier=>"bar"}, {:type=>{:keyword=>"int"}}, {:identifier=>"baz"}]
    end

    it "parses function prototypes without anonymous parameters" do
      @parser.parse('const char *foo(int, int);')
    end

  end

end
    	

