module Libretsy
end

directory = File.expand_path(File.dirname(__FILE__))

require File.join(directory, 'libretsy', 'client')
require File.join(directory, 'libretsy', 'version')

