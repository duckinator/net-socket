require 'net/socket/version'
require 'socket'

module Net::Socket::TCP
  class Server < TCPServer
    def each_request(async = false, &block)
      return each_request_async(&block) if async

      loop { handle_request(accept(), &block) }
    end

    private
    def each_request_async(&block)
      Thread.new do
        loop do
          Thread.new(accept(), block) do |request, block|
            handle_request(request, &block)
          end
        end
      end

      # Return nil to avoid collecting references to Threads.
      nil
    end

    def handle_request(request, &block)
      yield request

      request.close
    end
  end
end
