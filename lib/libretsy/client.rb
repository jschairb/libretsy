module Libretsy
  class Client
    ATTRIBUTES = %w(password rets_version url username user_agent)
    attr_accessor *ATTRIBUTES

    def initialize(config = { })
      # NOTE: possibly, raise unless certain configs exist
      config.each { |k,v| send(:"#{k}=",v) }
    end

    def login
    end
  end
end
