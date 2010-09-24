require 'spec_helper'

describe Libretsy::Authenticator do
  before(:each) do
    @client = Libretsy::Client.new(default_client_attributes)
    @response = mock("response",
       :headers_hash => { "WWW-Authenticate" => "Digest realm=\"DTON\", nonce=\"e1fa8b7c8ab2f049f5db095f814d352a\", opaque=\"20d1ccc139e99b834857cae3bae672ca\", qop=\"auth\"" },
       :request      => mock("request", :uri => "http://www.example.com/rets/login.aspx", :host => "http://www.example.com",
                             :method => :post)
    )
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
    it "returns the authorization header" do
      @authenticator = Libretsy::Authenticator.new(@client,@response)
      Libretsy::Authenticator.authenticate(@client,@response).should == @authenticator.authorization_header
    end
  end

  describe "#authorization_header" do
    it "returns a hash" do
    end
  end

  describe "#cnonce" do
  end

  describe "#parse_response_headers" do
    it "sets the nonce from the response" do
      authenticator = Libretsy::Authenticator.new(@client, @response)
      authenticator.nonce.should_not be_nil
      authenticator.nonce.should == "e1fa8b7c8ab2f049f5db095f814d352a"
    end

    it "sets the realm from the response" do
      authenticator = Libretsy::Authenticator.new(@client, @response)
      authenticator.realm.should_not be_nil
      authenticator.realm.should == "DTON"
    end

    it "sets the qop from the response" do
      authenticator = Libretsy::Authenticator.new(@client, @response)
      authenticator.qop.should_not be_nil
      authenticator.qop.should == "auth"
    end

    it "sets the opaque from the response" do
      authenticator = Libretsy::Authenticator.new(@client, @response)
      authenticator.opaque.should_not be_nil
      authenticator.opaque.should == "20d1ccc139e99b834857cae3bae672ca"
    end
  end

  describe "#request_id" do
  end

end
