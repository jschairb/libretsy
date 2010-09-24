module Libretsy
  class Session

    attr_accessor :authorization_headers, :client, :nonce_count, :response

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
      end
    end

    def requires_authentication?
      @response && @response.code.to_s == '401'
    end

    protected
    def set_authorization_headers
      self.authorization_headers = Authenticator.authenticate(client,response)
    end
  end
end
