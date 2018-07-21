# frozen_string_literal: true

module ONVIF
  module Service
    class Soap < HTTP
      def initialize(**args)
        super(args)
      end

      def service(res, req); end
    end
  end
end
