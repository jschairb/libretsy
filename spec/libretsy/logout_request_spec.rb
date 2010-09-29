require 'spec_helper'

describe Libretsy::LogoutRequest do
  before(:each) do
    @client = Libretsy::Client.new(default_client_attributes)
    @client.session.response = authorized_login_response
    @client.session.send(:set_urls)
  end

  it "is sub-classed for request" do
    Libretsy::LogoutRequest.ancestors.include?(Libretsy::Request).should == true
  end

  describe "#initialize" do
  end

  describe "#self.request" do
    it "is delegated to the Request class" do
      Libretsy::LogoutRequest.should respond_to(:request)
    end
  end

  describe "#client" do
    it "sets the client" do
      Libretsy::LogoutRequest.new(@client).client.should be_kind_of(Libretsy::Client)
    end
  end

  describe "#headers" do
    before(:each) do
      @logout_request = Libretsy::LogoutRequest.new(@client)
    end

    it "returns a hash" do
      @logout_request.headers.should be_kind_of(Hash)
    end

    it "includes the required headers" do
      Libretsy::LogoutRequest::REQUIRED_HEADERS.each do |header|
        @logout_request.headers.keys.include?(header).should == true
      end
    end

    it "includes optional headers if not nil" do
      keys = @logout_request.optional_headers.delete_if { |k,v| v.nil? }
      keys.each { |key,value| @logout_request.headers.keys.include?(key).should == true }
    end

    it "does not include items with nil values" do
      @logout_request.headers.select { |k,v| v.nil? }.should_not be_any
    end
  end

  describe "#optional_headers" do
    before(:each) do
      @logout_request = Libretsy::LogoutRequest.new(@client)
    end

    it "returns a hash" do
      @logout_request.optional_headers.should be_kind_of(Hash)
    end

    it "includes keys for the optional header fields" do
      Libretsy::LogoutRequest::OPTIONAL_HEADERS.each do |header|
        @logout_request.optional_headers.keys.include?(header).should == true
      end
    end
  end

  describe "#path" do
    it "returns the clients default_path" do
      request = Libretsy::LogoutRequest.new(@client)
      request.path.should == @client.session.urls[:logout]
    end
  end

  describe "#required_headers" do
    before(:each) do
      @logout_request = Libretsy::LogoutRequest.new(@client)
    end

    it "returns a hash" do
      @logout_request.required_headers.should be_kind_of(Hash)
    end

    it "includes keys for the required header fields" do
      Libretsy::LogoutRequest::REQUIRED_HEADERS.each do |header|
        @logout_request.required_headers.keys.include?(header).should == true
      end
    end
  end

end
