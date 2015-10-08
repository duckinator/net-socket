# Net::Socket

A fancy-pants socket API for Ruby.

## Bugs

This is actually a bug with Ruby, not Net::Socket, but if you `require 'net/socket'` between creating a `Net::HTTP` or `Net::FTP` instance, Net::HTTP or Net::FTP may raise an "uninitialized constant" exception. The reason for this is that Net::HTTP and Net::FTP reference `Socket`, which winds up referencing Net::Socket. There is a small hack-ish fix for this in [lib/net/socket/socket-hack.rb](https://gitlab.com/spinny/net-socket/blob/main/lib/net/socket/socket-hack.rb), and I will be submitting a pull request to fix it in Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'net-socket'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install net-socket

## Usage

```ruby
# Yay echo server!

require 'net/socket'
include Net::Socket

async = !!ARGV.delete('--async')
socket = TCP::Server.new('0.0.0.0', 9001)

socket.each_request(async) do |conn|
  conn.puts conn.read
end

socket.wait # Wait for the socket to close.
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://gitlab.com/spinny/net-socket/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
