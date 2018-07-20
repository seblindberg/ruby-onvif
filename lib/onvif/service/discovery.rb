# frozen_string_literal: true

module ONVIF
  module Service
    class Discovery
      include Service

      HOST = '239.255.255.250'
      PORT = 3702

      def initialize
        @d_socket = UDPSocket.new
        @r_socket = UDPSocket.new

        @d_socket.bind HOST, PORT

        freeze
      end

      # @return [Array<Socket>] an array of sockets that the service wants
      #   handled.
      def sockets
        [@d_socket]
      end

      # @param  socket [Socket] the socket that received an event.
      def handle(socket, _logger)
        raise UnknownSocket, socket unless @d_socket == socket

        msg, = @d_socket.recvfrom 4096

        p msg
      end
    end
  end
end
