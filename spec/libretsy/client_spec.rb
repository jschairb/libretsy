require 'spec_helper'

describe Libretsy::Client do
  before(:each) do
    @attributes = { :url => "http://example.com", :username => "rets-user", :password => "password",
      :user_agent => "libretsy/0.0.0", :rets_version => "RETS/1.5"
    }
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
