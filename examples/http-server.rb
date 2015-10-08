#!/usr/bin/env ruby

$: << File.join(File.dirname(__FILE__), '..', 'lib')

require 'net/socket'

include Net::Socket

async  = !!ARGV.delete('--async')
socket = TCP::Server.new("0.0.0.0", 8000)

puts "Server listening #{async ? 'a' : ''}synchronously at 0.0.0.0:8000."

socket.each_request(async) do |conn|
  # Store response in a variable so that we can get the exact length later.
  response = "<html><body>Hello from Ruby socket world!</body></html>"

  # Protocol, version, and status code. 
  conn.write "HTTP/1.0 200 OK\r\n"
  
  # Start headers.
  conn.write "Server: Ruby Met::Socket example\r\n"
  conn.write "Content-Type: text/html\r\n"
  conn.write "Content-Length: #{response.length}\r\n"
  conn.write "\r\n"
  # End headers.

  # Content.
  conn.write response
end

socket.wait
