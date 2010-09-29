module Libretsy
  class LogoutRequest < Request

    REQUIRED_HEADERS = %w(Accept RETS-Version User-Agent)
    OPTIONAL_HEADERS = %w(Accept-Encoding Authorization Cookie RETS-Request-ID)

    def headers
      required_headers.merge(optional_headers).merge(session.authorization_headers).
        delete_if { |k,v| v.nil? }
    end

    def required_headers
      { "Accept" => "*/*", "RETS-Version" => client.rets_version, "User-Agent" => client.user_agent }
    end

    def optional_headers
      { "Accept-Encoding" => nil, "Authorization" => nil, "Cookie" => nil, "RETS-Request-ID" => nil }
    end

    def path
      client.session.urls[:logout]
    end

  end
end
