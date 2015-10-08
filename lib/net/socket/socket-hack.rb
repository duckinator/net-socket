require 'socket'

module Net::Socket
  ::Socket.constants.each do |name|
    const_set(name, ::Socket.const_get(name))
  end
end
