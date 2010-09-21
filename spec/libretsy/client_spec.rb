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
p    end
  end
end
