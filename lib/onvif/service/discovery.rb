# frozen_string_literal: true

module ONVIF
  module Service
    class Discovery
      include Service

      MULTICAST_ADDR = '239.255.255.250'
      BIND_ADDR = '0.0.0.0'
      PORT = 3702

      def initialize
        @reply_socket = UDPSocket.new

        freeze
      end

      # @return [Array<Socket>] an array of sockets that the service wants
      #   handled.
      def sockets
        socket = UDPSocket.new
        membership = IPAddr.new(MULTICAST_ADDR).hton +
                     IPAddr.new(BIND_ADDR).hton

        socket.setsockopt :IPPROTO_IP, :IP_ADD_MEMBERSHIP, membership
        socket.bind BIND_ADDR, PORT

        [socket]
      end

      # @param  socket [Socket] the socket that received an event.
      def handle(socket, _logger)
        msg, = socket.recvfrom 4096

        p msg
      end

      def close
        @reply_socket.close
      end
    end
  end
end
