module Libretsy
  class Authenticator

    attr_accessor :client, :response

    def initialize(client, response)
      @client = client
      @response = response
    end

    def self.authenticate(client,response)
      new(client,response).authentication_headers
    end

    def authentication_headers
    end

    def cnonce
    end
  end
end
