require 'net/socket/version'
require 'net/socket/tcp/server'

module Net::Socket::TCP
  class ProtocolServer < Server
    def listen(async = false)
      each_request(async, &@@protocol.handler)
    end

    class Protocol < Struct.new(:states, :triggers, :initial_state)
      class Request < Struct.new(:socket, :states, :triggers)
        def initialize(socket, states, triggers, initial_state)
          super(socket, states, triggers)

          @current_state = initial_state
        end

        def run_next
          buff = ''

          until triggers[@current_state] === buff
            IO.select([socket])

            begin
              buff += socket.read_nonblock(1)
            rescue EOFError
              break
            end
          end

          @current_state = states[@current_state].call(socket, buff)
        end

        def done?
          @current_state == :done
        end
      end

      def handle(socket)
        request = Request.new(socket, states, triggers, initial_state)

        request.run_next until request.done?
      end

      def handler
        method(:handle)
      end
    end

    class ProtocolDSL
      def self.build(&block)
        self.new(&block).build
      end

      def initialize(&block)
        @states   = {}
        @triggers = {}

        instance_exec(&block)
        @current_state = @initial_state
      end

      def initial_state(name)
        @initial_state = name
      end

      def ready(hsh)
        hsh.each do |k, v|
          @triggers[k] = v
        end
      end

      def state(name, &block)
        @states[name] = block
      end

      def build
        Protocol.new(@states, @triggers, @initial_state)
      end
    end

    def self.protocol(&block)
      @@protocol = ProtocolDSL.build(&block)
    end
  end
end
