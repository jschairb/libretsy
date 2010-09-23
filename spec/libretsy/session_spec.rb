require 'spec_helper'

describe Libretsy::Session do
  before(:each) do
    @client = Libretsy::Client.new(default_client_attributes)
  end

  describe "#initialize" do
    it "requires a client" do
      lambda { Libretsy::Session.new(@client) }.should_not raise_exception
    end
  end

  describe "#client" do
    it "is set on initialization" do
      session = Libretsy::Session.new(@client)
      session.client.should_not be_nil
      session.client.should == @client
    end
  end

  describe "#login" do
    before(:each) do
      @session = Libretsy::Session.new(@client)
    end

    it "makes a LoginRequest" do

    end
  end

end
