# frozen_string_literal: true

module ONVIF
  module Service
    class HTTP
      include Service

      # @return [String] the default hostname that the TCP server should listen
      #   on.
      DEFAULT_HOST = 'localhost'

      # @return [Integer] the default port that the TCP server should listen on.
      DEFAULT_PORT = 4567

      # @param  config [WEBrick::Config]
      # @param  host [String] the hostname that the TCP server should listen on.
      # @param  port [Integer] the port that the TCP server should listen on.
      def initialize(config: WEBrick::Config::HTTP,
                     host: DEFAULT_HOST,
                     port: DEFAULT_PORT)
        @config = config.merge BindAddress: host, Port: port
      end

      # Returns a TCP server that acts like a socket.
      #
      # @return [Array<Socket>] an array of sockets that the service wants
      #   handled.
      def sockets
        [TCPServer.new(@config[:BindAddress], @config[:Port])]
      end

      # @param  socket [Socket] the socket that received an event.
      def handle(server, _logger)
        socket   = server.accept_nonblock
        request  = request_from socket
        response = response_from request

        service request, response

        response.send_response socket
      ensure
        socket.close
      end

      # @param  req [WEBrick::HTTPRequest] the HTTP request.
      # @param  req [WEBrick::HTTPResponse] the HTTP response, to be filled in.
      def service(_req, res)
        res.status = 200
      end

      private

      # Creates a new request from the given socket.
      #
      # @param  socket [TCPSocket] the client connection.
      # @return [WEBrick::HTTPRequest] a new HTTP request.
      def request_from(socket)
        req = WEBrick::HTTPRequest.new @config
        req.parse socket
        req
      end

      # Creates a new resonse form the given request.
      def response_from(req)
        res = WEBrick::HTTPResponse.new @config
        res.request_method       = req.request_method
        res.request_uri          = req.request_uri
        res.request_http_version = req.http_version
        res.keep_alive           = req.keep_alive?
        res
      end
    end
  end
end
