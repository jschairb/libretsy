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
      @unauthenticated_response = Typhoeus::Response.new(
        :code => 401, :body => "", :time => 0.1,
        :request => mock("request", :url => "http://example.com/rets/login.aspx", :host => "http://example.com", :method => :post),
        :headers => "HTTP/1.1 401 Unauthorized. Not Authenticated....\r\nServer: Microsoft-IIS/6.0\r\nX-AspNet-Version: 2.0.50727\r\nWWW-Authenticate: Digest realm=\"DTON\", nonce=\"94a14d9b9c246e41ade3d3245570208e\", opaque=\"4de82e6b3f767a86305a570dbfbb7089\", qop=\"auth\"\r\nCache-Control: private\r\nContent-Type: text/xml\r\nDate: Sat, 25 Sep 2010 01:25:56 GMT\r\nRETS-Version: RETS/1.5\r\nTransfer-Encoding: chunked\r\nConnection: Keep-Alive\r\nX-Powered-By: ASP.NET (L002)\r\n"
      )
      @authenticated_response   = Typhoeus::Response.new(
        :code => 200, :time => 0.1,
        :headers => "HTTP/1.1 200 OK\r\nDate: Sat, 25 Sep 2010 01:25:56 GMT\r\nServer: Microsoft-IIS/6.0\r\nX-Powered-By: ASP.NET (L004)\r\nX-AspNet-Version: 2.0.50727\r\nSet-Cookie: RETS-Session-ID=9559c89451d14069b5d66550ab3c7754; path=/\r\nRETS-Version: RETS/1.5\r\nTransfer-Encoding: chunked\r\nCache-Control: private\r\nContent-Type: text/xml; charset=utf-8\r\n\r\n",
        :body    => "<RETS ReplyCode=\"0\" ReplyText=\"Operation successful.\" >\r\n<RETS-RESPONSE>\r\nMemberName=Joshua D. Schairbaum\r\nUser=JDSRETS109,NULL,NULL,990000195\r\nBroker=999000998\r\nMetadataVersion=01.50.91625\r\nMinMetadataVersion=01.50.91625\r\nTimeoutSeconds=1800\r\nGetObject=/Dayton/DTON/getobject.aspx\r\nLogin=/Dayton/DTON/login.aspx\r\nLogout=/Dayton/DTON/logout.aspx\r\nSearch=/Dayton/DTON/search.aspx\r\nGetMetadata=/Dayton/DTON/getmetadata.aspx\r\n</RETS-RESPONSE>\r\n</RETS>\r\n"
      )
    end

    it "makes a LoginRequest" do
      Libretsy::LoginRequest.should_receive(:request).
        and_return(@unauthenticated_response,@authenticated_response)
      @session.login
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
