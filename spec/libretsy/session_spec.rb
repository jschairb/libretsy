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
      @unauthenticated_response = unauthorized_login_response
      @authenticated_response = authorized_login_response
    end

    it "makes a LoginRequest" do
      Libretsy::LoginRequest.should_receive(:request).
        and_return(@unauthenticated_response,@authenticated_response)
      @session.login
    end
  end

  describe "#logout" do
    before(:each) do
      @session = Libretsy::Session.new(@client)
    end

    it "makes a LogoutRequest" do
      Libretsy::LogoutRequest.should_receive(:request)
      @session.logout
    end

    it "resets the nonce_count" do
      Libretsy::LogoutRequest.should_receive(:request)
      @session.logout
      @session.nonce_count.should == 0
    end
  end

  describe "#requires_authentication?" do
    it "returns true if the response code is 401" do
      session = Libretsy::Session.new(@client)
      session.response = mock("response", :code => 401)
      session.requires_authentication?.should == true
    end
  end

end
