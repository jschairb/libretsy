require 'typhoeus'

module Libretsy
  class Request

    attr_accessor :client, :response, :session

    def initialize(client)
      @client  = client
      @session = client.session
    end

    def self.request(client)
      new(client).do_request
    end

    def do_request
      @response = Typhoeus::Request.post(url,
                                         :headers => headers,
                                         :password => client.password,
                                         :username => client.username,
                                         :user_agent => client.user_agent )
    end

    def headers
      { }
    end

    def path
      client.default_path
    end

    def url
      client.host + path
    end
  end
end
