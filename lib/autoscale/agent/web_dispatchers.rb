module Autoscale
  module Agent
    class WebDispatchers
      class AlreadySetError < StandardError
      end

      include Enumerable

      DISPATCH_INTERVAL = 15

      attr_reader :queue_time

      def initialize
        @dispatchers = []
      end

      def queue_time=(dispatcher)
        raise AlreadySetError if defined?(@queue_time)
        @dispatchers << (@queue_time = dispatcher)
      end

      def each(&block)
        @dispatchers.each(&block)
      end

      def prune
        each(&:prune)
      end

      def dispatch
        each(&:dispatch)
      rescue => err
        puts "Autoscale::Agent/WebDispatcher: #{err}\n#{err.backtrace.join("\n")}"
      end

      def run
        Thread.new do
          loop do
            prune
            dispatch
            sleep DISPATCH_INTERVAL
          end
        end
      end
    end
  end
end
