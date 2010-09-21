module Libretsy
  class LoginRequest < Request

    attr_accessor :client

    REQUIRED_HEADERS = %w(Accept RETS-Version User-Agent)
    OPTIONAL_HEADERS = %w(Accept-Encoding Authorization Cookie RETS-Request-ID)

    def initialize(client)
      @client = client
    end

    def headers
      required_headers.merge(optional_headers).delete_if { |k,v| v.nil? }
    end

    def required_headers
      { "Accept" => "*/*", "RETS-Version" => client.rets_version, "User-Agent" => client.user_agent }
    end

    def optional_headers
      { "Accept-Encoding" => "text/xml", "Authorization" => nil, "Cookie" => nil, "RETS-Request-ID" => nil }
    end
  end
end
