# frozen_string_literal: true

module ONVIF
  class Server
    # @return [Logger] the server logger.
    attr_reader :logger

    def initialize(services, logger: Logger.new(STDOUT))
      @logger       = logger
      @socket_table = {}

      populate_socket_table @socket_table, services
    end

    def run
      sockets = @socket_table.keys

      loop do
        events, = IO.select(sockets)
        socket, = events
        service = @socket_table.fetch socket

        logger.info "Req #{socket.remote_address.inspect} -> #{service.inspect}"
        service.handle socket, logger
      end
    end

    private

    def populate_socket_table(table, services)
      services.each do |service|
        service.sockets.each { |s| table[s] = service }
      end
    end
  end
end
