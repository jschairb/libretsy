require 'spec_helper'
require 'uri'

describe Libretsy::Client do
  before(:each) do
    @attributes = default_client_attributes
  end

  describe "#initialize" do
    it "requires a URL in the configs" do
      lambda { Libretsy::Client.new({:url => "http://example.com/rets/login.aspx"})}.
        should_not raise_exception
    end

    it "can set attributes" do
      client = Libretsy::Client.new(@attributes)
      Libretsy::Client::ATTRIBUTES.each do |attr|
        @attributes.keys.include?(attr.to_sym).should == true
      end
      @attributes.each do |k,v|
        client.send(:"#{k}").should == v
      end
    end

    it "sets the URI" do
      client = Libretsy::Client.new(@attributes)
      client.uri.should_not be_nil
      client.uri.should == URI.parse(@attributes[:url])
    end
  end

  describe "#default_path" do
    it "returns the path of the url" do
      client = Libretsy::Client.new(@attributes)
      client.default_path.should == URI.parse(@attributes[:url]).path
    end
  end

  describe "#host" do
    it "returns the port, path, & scheme or the URL" do
      client = Libretsy::Client.new(@attributes)
      client.host.should == "http://example.com:6103"
    end
  end

  describe "#session" do
    before(:each) do
      @client = Libretsy::Client.new(default_client_attributes)
    end

    it "gets cached so it does not repeat itself" do
      session = mock("session")
      Libretsy::Session.should_receive(:new).and_return(session)
      @client.session.should == session
      @client.session.should == session
    end
  end

  describe "#uri" do

  end
end
