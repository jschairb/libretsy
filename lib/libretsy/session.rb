module Libretsy
  class Session

    attr_accessor :authorization_headers, :client, :cookie, :nonce_count, :response, :server_info, :urls

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
        increment_nonce_count
        parse_authentication_login_response
      end
    end

    def logout
      @response = Libretsy::LogoutRequest.request(client)
      reset_nonce_count
    end

    def requires_authentication?
      @response && @response.code.to_s == '401'
    end

    protected
    def increment_nonce_count
      @nonce_count += 1
    end

    def parse_authentication_login_response
      self.cookie = @response.headers_hash["Set-Cookie"]
      set_urls
    end

    def reset_nonce_count
      @nonce_count = 0
    end

    def select_value(key)
      @response.body.split("\r\n").select{|s| s.include?(key)}.first.split("=")[1]
    end

    def set_authorization_headers
      self.authorization_headers = Authenticator.authenticate(client,response)
    end

    def set_urls
      self.urls = { :get_metadata => select_value("GetMetadata"),
                    :get_object   => select_value("GetObject"),
                    :login        => select_value("Login"),
                    :logout       => select_value("Logout"),
                    :search       => select_value("Search") }
    end
  end
end

