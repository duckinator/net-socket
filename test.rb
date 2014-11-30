require 'net/socket'

include Net::Socket

# Ruby port of https://github.com/duckinator/ooch/blob/master/ooch.ooc

socket = TCP::Server.new("0.0.0.0", 8000)

socket.each_request(true) do |conn|
  # Start headers.
  conn.write "HTTP/1.0 200 OK\r\n"
  conn.write "Server: ooc httpd\r\n"
  conn.write "Content-Type: text/html\r\n"
  conn.write "Content-Length: 59\r\n"
  conn.write "\r\n"
  # End headers

  # Content
  conn.write "<html><body>Hello, from the Ruby socket world!</body></html>"
end

sleep
