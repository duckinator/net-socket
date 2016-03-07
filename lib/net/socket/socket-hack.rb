require 'net/http'
require 'net/ftp'

# Net::HTTP and Net::FTP reference +Socket+, so wind up referencing
# +Net::Socket+ normally.
#
# This defines +Net::HTTP::Socket+ and +Net::FTP::Socket+ as aliases
# for +::Socket+, thus avoiding errors.

class Net::HTTP
  Socket = ::Socket
end

class Net::FTP
  Socket = ::Socket
end
