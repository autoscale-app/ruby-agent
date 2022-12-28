module Autoscale
  module Agent
    class WorkerServer
      attr_reader :token

      def initialize(token, &block)
        @token = token
        @block = block
      end

      def serve
        @block.call
      end
    end
  end
end
