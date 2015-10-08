# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'net/socket/version'

Gem::Specification.new do |spec|
  spec.name          = "net-socket"
  spec.version       = Net::Socket::VERSION
  spec.authors       = ["Marie Markwell"]
  spec.email         = ["me@marie.so"]

  spec.summary       = %q{A nice wrapper for Ruby's built in socket APIs.}
  spec.description   = spec.summary
  spec.homepage      = "https://gitlab.com/spinny/net-socket"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
end
