require 'net/socket/version'
require 'net/socket/tcp/server'

module Net::Socket::TCP
  class ProtocolServer < Server
    def listen(async = false)
      each_request(async, &@@protocol.handler)
    end

    class Protocol < Struct.new(:states, :initial_state)
      class Request < Struct.new(:socket, :states)
        def initialize(socket, states, initial_state)
          super(socket, states)

          @current_state = initial_state
        end

        def run_next
          separator, block = states[@current_state]

          buff = ''

          until separator === buff
            # What the fuck?
            begin
              buff += socket.read_nonblock(1)
            rescue IO::WaitReadable
              # ????
              # This feels very, very wrong.
              # You know, on top of how wrong the whole begin/rescue
              # bullshit felt to start with.
              break if separator == :rest

              IO.select([socket])
              retry
            rescue EOFError
              # Do nothing.
            end
          end

          @current_state = block.call(socket, buff)
        end

        def done?
          @current_state == :done
        end
      end

      def handle(socket)
        request = Request.new(socket, states, initial_state)

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
        instance_exec(&block)
        @current_state = @initial_state
      end

      def initial_state(name)
        @initial_state = name
      end

      def state(name, regexp = nil, separator, &block)
        separator = Regexp.compile(Regexp.escape(separator)) if separator.is_a?(String)

        @states ||= {}
        @states[name] = [separator, block]
      end

      def build
        Protocol.new(@states, @initial_state)
      end
    end

    def self.protocol(&block)
      @@protocol = ProtocolDSL.build(&block)
    end
  end
end
