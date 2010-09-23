module Libretsy
  class Session

    attr_accessor :client, :nonce_count, :request, :response

    def initialize(client)
      @client = client
      @nonce_count = 0
    end

    def authorization_headers
      { }
    end

    def login
      @request, @response = Libretsy::LoginRequest.request(client)

      if requires_authentication?
        self.authorization_headers = Authenticator.authenticate(client,request,response)
        @response = Lib
      end
    end

    def logout
#      @response = Libretsy::LogoutRequest.request(client)
    end

    def requires_authentication?
      @response && @response.code.to_s == '401'
    end

  end
end
