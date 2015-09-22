#!/usr/bin/env ruby

$: << File.join(File.dirname(__FILE__), '..', 'lib')

require 'net/socket'

include Net::Socket

async  = ARGV[0] == '--async'
socket = TCP::Server.new("0.0.0.0", 8000)

puts "Server listening #{async ? 'a' : ''}synchronously at 0.0.0.0:8000."

socket.each_request(async) do |conn|
  # Start headers.
  conn.write "HTTP/1.0 200 OK\r\n"
  conn.write "Server: Ruby net::socket example\r\n"
  conn.write "Content-Type: text/html\r\n"
  conn.write "Content-Length: 59\r\n"
  conn.write "\r\n"
  # End headers

  # Content
  conn.write "<html><body>Hello, from the Ruby socket world!</body></html>"
end

sleep