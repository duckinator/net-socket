#!/usr/bin/env ruby

$: << File.join(File.dirname(__FILE__), '..', 'lib')

require 'net/socket'

# A HTTP server that returns the request, in the body of an HTML document.
class DumpServer < Net::Socket::TCP::ProtocolServer
  protocol do
    initial_state :request

    # Request.
    # [method] [url] HTTP/[version]
    state(:request, "\r\n") do |_, line|
      @method, @url, protocol = line.split(' ')
      @version = protocol.split('/').last

      next :header
    end

    # Headers.
    # [key]: [value]
    state(:header, "\r\n") do |_, line|
      # TODO: Define transitions separately?
      next :body if line.strip.empty?

      key, value = line.split(': ', 2)

      @headers ||= {}
      @headers[key] = value.strip

      next :header
    end

    # Body (everything that is left).
    # FIXME: If Content-Length is not specified and no EOF is received
    # (technically making the connection a stream), it will blow up
    # because @headers['Content-Length'] is nil, and nil.to_i makes
    # Ruby angry.
    state(:body, ->(buff) {buff.length == @headers['Content-Length'].to_i}) do |conn, body|
      # Start headers
      conn.write "HTTP/1.0 200 OK\r\n"
      conn.write "Server: some trashy Ruby httpd\r\n"
      conn.write "Content-Type: text/html\r\n"
      conn.write "Content-Length: 59\r\n"
      conn.write "\r\n"
      # End headers

      # Content
      conn.write "<html><body><pre>"
      conn.write "#{@method} #{@url} HTTP/#{@version}\r\n"
      conn.write @headers.map{|k, v| "#{k}: #{v}"}.join("\r\n")
      conn.write "</pre></body></html>"

      next :done
    end
  end
end

async  = ARGV[0] == '--async'
puts "Server listening #{async ? 'a' : ''}synchronously at 0.0.0.0:8000."

DumpServer.new('0.0.0.0', 8000).listen(async)
