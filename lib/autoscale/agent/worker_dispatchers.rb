module Autoscale
  module Agent
    class WorkerDispatchers
      include Enumerable

      DISPATCH_INTERVAL = 15

      def initialize
        @dispatchers = []
      end

      def each(&block)
        @dispatchers.each(&block)
      end

      def <<(dispatcher)
        @dispatchers << dispatcher
      end

      def dispatch
        each do |dispatcher|
          dispatcher.dispatch
        rescue => err
          puts "Autoscale::Agent/WorkerDispatcher: #{err}\n#{err.backtrace.join("\n")}"
        end
      end

      def run
        Thread.new do
          loop do
            dispatch
            sleep DISPATCH_INTERVAL
          end
        end
      end
    end
  end
end
