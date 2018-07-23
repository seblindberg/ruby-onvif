# frozen_string_literal: true

module ONVIF
  module Service
    class Discovery
      include Service

      MULTICAST_ADDR = '239.255.255.250'
      PORT = 3702

      PACKET_SIZE = 1024
      private_constant :PACKET_SIZE

      def initialize(local_address: auto_select_address)
        @reply_socket = UDPSocket.new
        @local_address = local_address

        freeze
      end

      # @return [Array<Socket>] an array of sockets that the service wants
      #   handled.
      def sockets
        socket = UDPSocket.new
        socket.setsockopt :SOL_SOCKET, :SO_REUSEADDR, true
        socket.bind MULTICAST_ADDR, PORT

        membership = IPAddr.new(MULTICAST_ADDR).hton +
                     IPAddr.new(@local_address).hton
        socket.setsockopt :IPPROTO_IP, :IP_ADD_MEMBERSHIP, membership

        [socket]
      end

      # @param  socket [Socket] the socket that received an event.
      def handle(socket, _logger)
        msg, = socket.recvfrom PACKET_SIZE

        p msg
      end

      def close
        @reply_socket.close
      end

      private

      def auto_select_address
        addrinfo = Socket.ip_address_list.find(&:ipv4_private?)
        return unless addrinfo
        addrinfo.ip_address
      end
    end
  end
end
