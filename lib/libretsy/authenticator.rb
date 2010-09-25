require 'digest/md5'

module Libretsy
  class Authenticator

    attr_accessor :authorization_response_hash, :client, :nonce, :opaque, :qop, :realm, :response

    def initialize(client, response)
      @client = client
      @response = response
      parse_response_headers(@response)
    end

    def self.authenticate(client,response)
      authenticator = new(client,response)
      return authenticator.authorization_header
    end

    def authorization_header
      header = ""
      header << "Digest username=\"#{client.username}\", "
      header << "realm=\"#{realm}\", "
      header << "qop=\"#{qop}\", "
      header << "uri=\"#{request_uri}\", "
      header << "nonce=\"#{nonce}\", "
      header << "nc=\"#{nc_value}\", "
      header << "cnonce=\"#{cnonce}\", "
      header << "response=\"#{calculate_digest}\", "
      header << "opaque=\"#{opaque}\""

      { "Authorization" => header }
    end

    def cnonce
      Digest::MD5.hexdigest("#{client.username}:#{client.password}:#{nonce}")
    end

    def nc_value
      '%08x' % client.session.nonce_count
    end

    def request_method
      response.request.method.to_s.upcase
    end

    def request_uri
      response.request.url.gsub(response.request.host, "")
    end

    protected
    def calculate_digest
      ha1 = Digest::MD5.hexdigest("#{client.username}:#{realm}:#{client.password}")
      ha2 = Digest::MD5.hexdigest("#{request_method}:#{request_uri}")
      qop ? digest_with_cnonce(ha1,ha2) : digest_without_cnonce(ha1,ha2)
    end

    def digest_with_cnonce(ha1,ha2)
      digest = "#{ha1}:#{nonce}:#{nc_value}:#{cnonce}:#{qop}:#{ha2}"
      Digest::MD5.hexdigest(digest)
    end

    def digest_without_cnonce(ha1, ha2)
      digest = "#{ha1}:#{nonce}:#{ha2}"
      Digest::MD5.hexdigest(digest)
    end

    def parse_response_headers(response)
      parse_authorization_response_header(response.headers_hash["WWW-Authenticate"])
      self.nonce  = authorization_response_hash["nonce"]
      self.opaque = authorization_response_hash["opaque"]
      self.qop    = authorization_response_hash["qop"]
      self.realm  = authorization_response_hash["realm"]
    end

    def parse_authorization_response_header(header)
      self.authorization_response_hash = header.gsub(/Digest |\"/, "").split(", ").
        inject({}){|headers, header| k,v = *header.split("="); headers.merge(k=>v) }
    end
  end
end
