$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'libretsy'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|

end

def default_client_attributes(attributes={ })
  { :url => "http://example.com", :username => "rets-user", :password => "password",
    :user_agent => "libretsy/0.0.0", :rets_version => "RETS/1.5"
  }.merge(attributes)
end
