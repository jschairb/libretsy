module Libretsy
  class Client
    ATTRIBUTES = %w(password rets_version url username user_agent)
    attr_accessor *ATTRIBUTES

    def initialize(config = { })
      raise ArgumentError unless config.keys.include?(:url)
      config.each { |k,v| send(:"#{k}=",v) }
      @uri = URI.parse(@url) if @url
    end

    def default_path
      uri.path
    end

    def host
      uri.to_s.gsub(uri.path,"")
    end

    def session
      @session ||= Session.new(self)
    end

    def uri
      @uri
    end
  end
end
