#!/usr/bin/env ruby

$: << File.join(File.dirname(__FILE__), '..', 'lib')

require 'net/socket'

include Net::Socket

async  = !!ARGV.delete('--async')

uri = URI.parse('http://da.gd/ip')
socket = TCP::Client.new(uri.host, uri.port)

socket.puts "GET #{uri.path} HTTP/1.1"
socket.puts "Host: #{uri.host}"
socket.puts "Accept: text/plain"
socket.puts ""

puts socket.read
socket.close
