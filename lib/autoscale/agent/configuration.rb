module Autoscale
  module Agent
    class Configuration
      class BlockMissingError < StandardError; end

      class PlatformMissingError < StandardError; end

      class InvalidPlatformError < StandardError; end

      class << self
        attr_writer :run

        def run?
          !defined?(@run) || @run == true
        end
      end

      def initialize(&block)
        instance_eval(&block)

        if Configuration.run?
          web_dispatchers.run
          worker_dispatchers.run
        end
      end

      def platform(value = nil)
        if value
          @platform = validate_platform(value)
        else
          @platform || raise(PlatformMissingError)
        end
      end

      def web_dispatchers
        @web_dispatchers ||= WebDispatchers.new
      end

      def worker_dispatchers
        @worker_dispatchers ||= WorkerDispatchers.new
      end

      def worker_servers
        @worker_servers ||= WorkerServers.new
      end

      def dispatch(token, &block)
        if block
          dispatch_worker(token, &block)
        else
          dispatch_web(token)
        end
      end

      def serve(token, &block)
        raise BlockMissingError, "missing block" unless block
        worker_servers << WorkerServer.new(token, &block)
      end

      private

      def dispatch_web(token)
        web_dispatchers.queue_time = WebDispatcher.new(token)
      end

      def dispatch_worker(token, &block)
        worker_dispatchers << WorkerDispatcher.new(token, &block)
      end

      def validate_platform(value)
        case value
        when :render
          value
        else
          raise InvalidPlatformError, "currently the only valid option is :render"
        end
      end
    end
  end
end
