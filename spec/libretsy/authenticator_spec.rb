require 'spec_helper'

describe Libretsy::Authenticator do
  before(:each) do
    @client = Libretsy::Client.new(default_client_attributes)
    @response = { }
  end

  it "requires a client and a response as arguments" do
    lambda { Libretsy::Authenticator.new(@client, @response) }.should_not raise_exception
  end

  describe "#initialize" do
    it "sets a client" do
      authenticator = Libretsy::Authenticator.new(@client, @response)
      authenticator.client.should == @client
    end

    it "sets a response" do
      authenticator = Libretsy::Authenticator.new(@client, @response)
      authenticator.response.should == @response
    end
  end

  describe "#self.authenticate" do
    it "creates a new Authenticator" do
      @authenticator = Libretsy::Authenticator.new(@client,@response)
      Libretsy::Authenticator.should_receive(:new).with(@client,@response).and_return(@authenticator)
      Libretsy::Authenticator.authenticate(@client,@response)
    end

    it "returns the authentication headers" do
      @authenticator = Libretsy::Authenticator.new(@client,@response)
      Libretsy::Authenticator.stub!(:new).and_return(@authenticator)
      Libretsy::Authenticator.authenticate(@client,@response).should == @authenticator.authentication_headers
    end
  end


end
