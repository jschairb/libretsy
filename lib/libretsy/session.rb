module Libretsy
  class Session

    attr_accessor :authorization_headers, :client, :cookie, :nonce_count, :response

    def initialize(client)
      @authorization_headers = {}
      @client = client
      @nonce_count = 0
    end

    def login
      @response = Libretsy::LoginRequest.request(client)
      if requires_authentication?
        set_authorization_headers
        @response = Libretsy::LoginRequest.request(client)
        parse_authentication_login_response
      end
    end

    def requires_authentication?
      @response && @response.code.to_s == '401'
    end

    protected
    def parse_authentication_login_response
      self.cookie = @response.headers_hash["Set-Cookie"]
    end

    def set_authorization_headers
      self.authorization_headers = Authenticator.authenticate(client,response)
    end
  end
end

# Successful Headers
# HTTP/1.1 200 OK
# Date: Fri, 24 Sep 2010 19:36:16 GMT
# Server: Microsoft-IIS/6.0
# X-Powered-By: ASP.NET (L004)
# X-AspNet-Version: 2.0.50727
# Set-Cookie: RETS-Session-ID=038f427b60f14e13beb46822e003237a; path=/
# RETS-Version: RETS/1.5
# Transfer-Encoding: chunked
# Cache-Control: private
# Content-Type: text/xml; charset=utf-8

# SUCCESSFUL RESPONSE BODY
# <RETS ReplyCode="0" ReplyText="Operation successful." >
# <RETS-RESPONSE>
# MemberName=Joshua D. Schairbaum
# User=JDSRETS109,NULL,NULL,990000195
# Broker=999000998
# MetadataVersion=01.50.91625
# MinMetadataVersion=01.50.91625
# TimeoutSeconds=1800
# GetObject=/Dayton/DTON/getobject.aspx
# Login=/Dayton/DTON/login.aspx
# Logout=/Dayton/DTON/logout.aspx
# Search=/Dayton/DTON/search.aspx
# GetMetadata=/Dayton/DTON/getmetadata.aspx
# </RETS-RESPONSE>
# </RETS>
