module Autoscale
  module Agent
    class WorkerServers
      include Enumerable

      def initialize
        @servers = []
      end

      def each(&block)
        @servers.each(&block)
      end

      def <<(server)
        @servers << server
      end

      def find(tokens)
        @servers.find { |server| tokens.include?(server.token) }
      end
    end
  end
end
