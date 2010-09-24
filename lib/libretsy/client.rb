module Libretsy
  class Client
    ATTRIBUTES = %w(password rets_version url username user_agent)
    attr_accessor *ATTRIBUTES

    def initialize(config = { })
      config.each { |k,v| send(:"#{k}=",v) }
    end

    def session
      @session ||= Session.new(self)
    end
  end
end
