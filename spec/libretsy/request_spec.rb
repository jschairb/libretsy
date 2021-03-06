require 'spec_helper'

describe Libretsy::Request do
  before(:each) do
    @client = Libretsy::Client.new(default_client_attributes)
  end

  describe "#initialize" do
  end

  describe "#self.request" do
    it "calls new on the LoginRequest" do
      request = mock("request", :do_request => "")
      Libretsy::Request.should_receive(:new).and_return(request)
      Libretsy::Request.request(@client)
    end

    it "runs a login_request" do
      request = mock("login_request")
      request.should_receive(:do_request)
      Libretsy::Request.stub!(:new).and_return(request)
      Libretsy::Request.request(@client)
    end
  end

  describe "#client" do
    it "sets the client" do
      Libretsy::Request.new(@client).client.should be_kind_of(Libretsy::Client)
    end
  end

  describe "#do_request" do
    before(:each) do
      @response = mock("response", :code => 200, :request => { })
    end

    it "makes a Typhoeus request" do
      Typhoeus::Request.should_receive(:post).and_return(@response)
      request = Libretsy::Request.new(@client)
      request.do_request
    end

    it "sets a response object" do
      Typhoeus::Request.stub!(:post).and_return(@response)

      request = Libretsy::Request.new(@client)
      request.response.should be_nil

      request.do_request
      request.response.should_not be_nil
    end
  end

  describe "#path" do
    it "returns the clients default_path" do
      request = Libretsy::Request.new(@client)
      request.path.should == @client.default_path
    end
  end

  describe "#session" do
    it "sets the session" do
      session = Libretsy::Request.new(@client).session
      session.should_not be_nil
      session.should == @client.session
      session.should be_kind_of(Libretsy::Session)
    end
  end
end
