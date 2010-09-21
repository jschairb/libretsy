require 'spec_helper'

describe Libretsy::LoginRequest do
  before(:each) do
    @client = Libretsy::Client.new(default_client_attributes)
  end

  it "is sub-classed for request" do
    Libretsy::LoginRequest.ancestors.include?(Libretsy::Request).should == true
  end

  describe "#initialize" do
  end

  describe "#self.request" do
    it "is delegated to the Request class" do
      Libretsy::LoginRequest.should respond_to(:request)
    end
  end

  describe "#client" do
    it "sets the client" do
      Libretsy::LoginRequest.new(@client).client.should be_kind_of(Libretsy::Client)
    end
  end

  describe "#headers" do
    before(:each) do
      @login_request = Libretsy::LoginRequest.new(@client)
    end

    it "returns a hash" do
      @login_request.headers.should be_kind_of(Hash)
    end

    it "includes the required headers" do
      Libretsy::LoginRequest::REQUIRED_HEADERS.each do |header|
        @login_request.headers.keys.include?(header).should == true
      end
    end

    it "includes optional headers if not nil" do
      keys = @login_request.optional_headers.delete_if { |k,v| v.nil? }
      keys.each { |key,value| @login_request.headers.keys.include?(key).should == true }
    end

    it "does not include items with nil values" do
      @login_request.headers.select { |k,v| v.nil? }.should_not be_any
    end
  end

  describe "#optional_headers" do
    before(:each) do
      @login_request = Libretsy::LoginRequest.new(@client)
    end

    it "returns a hash" do
      @login_request.optional_headers.should be_kind_of(Hash)
    end

    it "includes keys for the optional header fields" do
      Libretsy::LoginRequest::OPTIONAL_HEADERS.each do |header|
        @login_request.optional_headers.keys.include?(header).should == true
      end
    end
  end

  describe "#required_headers" do
    before(:each) do
      @login_request = Libretsy::LoginRequest.new(@client)
    end

    it "returns a hash" do
      @login_request.required_headers.should be_kind_of(Hash)
    end

    it "includes keys for the required header fields" do
      Libretsy::LoginRequest::REQUIRED_HEADERS.each do |header|
        @login_request.required_headers.keys.include?(header).should == true
      end
    end
  end

end
