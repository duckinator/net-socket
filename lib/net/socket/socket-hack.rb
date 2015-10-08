require 'net/http'
require 'net/ftp'

class Net::HTTP
  Socket = ::Socket
end

class Net::FTP
  Socket = ::Socket
end
