require 'typhoeus'

module Libretsy
  class Request

    attr_accessor :client, :response

    def initialize(client)
      @client = client
    end

    def self.request(client)
      new(client).do_request
    end

    def do_request
      @response = Typhoeus::Request.post(client.url, :headers => headers, :password => client.password,
                                                     :username => client.username, :user_agent => client.user_agent,
                                                     :auth_method => :CURLAUTH_DIGEST )
      if requires_authentication?
        credentials = Libretsy::Authenticator.authenticate(client, response)
      end
    end

    def headers
      { }
    end

    def requires_authentication?
      @response && @response.code.to_s == '401'
    end
  end
end
