# frozen_string_literal: true

module ONVIF
  module Service
    class ServiceError < Error; end
    class UnknownSocket < ServiceError
      def initialize(socket)
        super "Unknown socket: #{socket.inspect}"
      end
    end

    def sockets
      []
    end
  end
end
