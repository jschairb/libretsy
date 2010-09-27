require 'spec_helper'
require 'digest/md5'

describe Libretsy::Authenticator do
  before(:each) do
    @client = Libretsy::Client.new(default_client_attributes)
    @response = Typhoeus::Response.new(
        :code => 401, :body => "", :time => 0.1,
        :request => mock("request", :url => "http://example.com/rets/login.aspx", :host => "http://example.com", :method => :post),
        :headers => "HTTP/1.1 401 Unauthorized. Not Authenticated....\r\nServer: Microsoft-IIS/6.0\r\nX-AspNet-Version: 2.0.50727\r\nWWW-Authenticate: Digest realm=\"RETS\", nonce=\"94a14d9b9c246e41ade3d3245570208e\", opaque=\"4de82e6b3f767a86305a570dbfbb7089\", qop=\"auth\"\r\nCache-Control: private\r\nContent-Type: text/xml\r\nDate: Sat, 25 Sep 2010 01:25:56 GMT\r\nRETS-Version: RETS/1.5\r\nTransfer-Encoding: chunked\r\nConnection: Keep-Alive\r\nX-Powered-By: ASP.NET (L002)\r\n"
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
      authenticator = Libretsy::Authenticator.new(@client, @response)
      authenticator.authorization_header.should be_kind_of(Hash)
    end

    it "has a single key to be merged with other headers" do
      authenticator = Libretsy::Authenticator.new(@client, @response)
      authenticator.authorization_header.keys.should == ["Authorization"]
    end
  end

  describe "#cnonce" do
    it "returns an md5 hash of the username, password, & nonce" do
      authenticator = Libretsy::Authenticator.new(@client, @response)
      hexed_string = "#{@client.username}:#{@client.password}:#{authenticator.nonce}"
      expected = Digest::MD5.hexdigest(hexed_string)
      authenticator.cnonce.should == expected
    end
  end

  describe "#ha_1" do
    it "returns a hash of the username, realm, & nonce" do
      authenticator = Libretsy::Authenticator.new(@client, @response)
      hexed_string = "#{@client.username}:#{authenticator.realm}:#{@client.password}"
      expected = Digest::MD5.hexdigest(hexed_string)
      authenticator.ha_1.should == expected
    end
  end

  describe "#ha_2" do
    it "returns a hash of the request method and request uri" do
      authenticator = Libretsy::Authenticator.new(@client, @response)
      hexed_string = "#{authenticator.request_method}:#{authenticator.request_uri}"
      expected = Digest::MD5.hexdigest(hexed_string)
      authenticator.ha_2.should == expected
    end
  end

  describe "#nc_value" do
    it "returns the clients nonce_count w/ 8 leading digits" do
      authenticator = Libretsy::Authenticator.new(@client, @response)
      @client.session.nonce_count.should == 0
      authenticator.nc_value.should == "00000000"
    end
  end

  describe "#request_method" do
    it "returns the capitalized request method from the response" do
      authenticator = Libretsy::Authenticator.new(@client, @response)
      authenticator.request_method.should == "POST"
    end
  end

  describe "#request_uri" do
    it "returns the URL minus the host information" do
      authenticator = Libretsy::Authenticator.new(@client, @response)
      authenticator.request_uri.should == "/rets/login.aspx"
    end
  end

  describe "#response_digest" do
    describe "with a qop value" do
      it "returns a digest with cnonce" do
        authenticator = Libretsy::Authenticator.new(@client, @response)
        authenticator.qop.should_not be_nil
        authenticator.response_digest.should == authenticator.send(:digest_with_cnonce)
      end
    end

    describe "without a qop value" do
      it "returns a digest without the cnonce" do
        response = Typhoeus::Response.new(
          :code => 401, :body => "", :time => 0.1,
          :request => mock("request", :url => "http://example.com/rets/login.aspx", :host => "http://example.com", :method => :post),
          :headers => "HTTP/1.1 401 Unauthorized. Not Authenticated....\r\nServer: Microsoft-IIS/6.0\r\nX-AspNet-Version: 2.0.50727\r\nWWW-Authenticate: Digest realm=\"RETS\", nonce=\"94a14d9b9c246e41ade3d3245570208e\", opaque=\"4de82e6b3f767a86305a570dbfbb7089\", Cache-Control: private\r\nContent-Type: text/xml\r\nDate: Sat, 25 Sep 2010 01:25:56 GMT\r\nRETS-Version: RETS/1.5\r\nTransfer-Encoding: chunked\r\nConnection: Keep-Alive\r\nX-Powered-By: ASP.NET (L002)\r\n"
        )
        authenticator = Libretsy::Authenticator.new(@client, response)
        authenticator.qop.should be_nil
        authenticator.response_digest.should == authenticator.send(:digest_without_cnonce)
      end
    end
  end

  describe "#parse_response_headers" do
    it "sets the nonce from the response" do
      authenticator = Libretsy::Authenticator.new(@client, @response)
      authenticator.nonce.should_not be_nil
      authenticator.nonce.should == "94a14d9b9c246e41ade3d3245570208e"
    end

    it "sets the realm from the response" do
      authenticator = Libretsy::Authenticator.new(@client, @response)
      authenticator.realm.should_not be_nil
      authenticator.realm.should == "RETS"
    end

    it "sets the qop from the response" do
      authenticator = Libretsy::Authenticator.new(@client, @response)
      authenticator.qop.should_not be_nil
      authenticator.qop.should == "auth"
    end

    it "sets the opaque from the response" do
      authenticator = Libretsy::Authenticator.new(@client, @response)
      authenticator.opaque.should_not be_nil
      authenticator.opaque.should == "4de82e6b3f767a86305a570dbfbb7089"
    end
  end
end
