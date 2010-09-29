$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'libretsy'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|

end

def default_client_attributes(attributes={ })
  { :url => "http://example.com:6103/rets/login.aspx", :username => "rets-user",
    :password => "password", :user_agent => "libretsy/0.0.0", :rets_version => "RETS/1.5"
  }.merge(attributes)
end

def authorized_login_response
  Typhoeus::Response.new(
    :code => 200, :time => 0.1,
    :headers => "HTTP/1.1 200 OK\r\nDate: Sat, 25 Sep 2010 01:25:56 GMT\r\nServer: Microsoft-IIS/6.0\r\nX-Powered-By: ASP.NET (L004)\r\nX-AspNet-Version: 2.0.50727\r\nSet-Cookie: RETS-Session-ID=9559c89451d14069b5d66550ab3c7754; path=/\r\nRETS-Version: RETS/1.5\r\nTransfer-Encoding: chunked\r\nCache-Control: private\r\nContent-Type: text/xml; charset=utf-8\r\n\r\n",
    :body    => "<RETS ReplyCode=\"0\" ReplyText=\"Operation successful.\" >\r\n<RETS-RESPONSE>\r\nMemberName=William H. Bonney\r\nUser=WHBRETS109,NULL,NULL,55378008\r\nBroker=55378008\r\nMetadataVersion=01.50.91625\r\nMinMetadataVersion=01.50.91625\r\nTimeoutSeconds=1800\r\nGetObject=/RETS/getobject.aspx\r\nLogin=/RETS/login.aspx\r\nLogout=/RETS/logout.aspx\r\nSearch=/RETS/search.aspx\r\nGetMetadata=/RETS/getmetadata.aspx\r\n</RETS-RESPONSE>\r\n</RETS>\r\n"
  )
end

def unauthorized_login_response
  Typhoeus::Response.new(
    :code => 401, :body => "", :time => 0.1,
    :request => mock("request", :url => "http://example.com/rets/login.aspx",
                     :host => "http://example.com", :method => :post),
    :headers => "HTTP/1.1 401 Unauthorized. Not Authenticated....\r\nServer: Microsoft-IIS/6.0\r\nX-AspNet-Version: 2.0.50727\r\nWWW-Authenticate: Digest realm=\"RETS\", nonce=\"94a14d9b9c246e41ade3d3245570208e\", opaque=\"4de82e6b3f767a86305a570dbfbb7089\", qop=\"auth\"\r\nCache-Control: private\r\nContent-Type: text/xml\r\nDate: Sat, 25 Sep 2010 01:25:56 GMT\r\nRETS-Version: RETS/1.5\r\nTransfer-Encoding: chunked\r\nConnection: Keep-Alive\r\nX-Powered-By: ASP.NET (L002)\r\n"
  )
end
