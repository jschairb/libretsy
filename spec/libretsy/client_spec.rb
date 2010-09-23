require 'spec_helper'

describe Libretsy::Client do
  before(:each) do
    @attributes = default_client_attributes
  end

  describe "#initialize" do
    it "does not require any argument" do
      lambda { Libretsy::Client.new() }.should_not raise_exception
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
end
