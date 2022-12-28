module Autoscale
  module Agent
    class WorkerDispatcher
      attr_reader :token

      def initialize(token, &block)
        @id = token.each_char.take(7).join
        @token = token
        @block = block
      end

      def dispatch
        if (value = @block.call)
          body = MultiJson.dump(Time.now.to_i => value)
          response = Request.dispatch(body, token: @token)

          unless response.is_a?(Net::HTTPOK)
            error "Failed to dispatch (#{response.code}) #{response.body}"
          end
        else
          error "Failed to calculate worker information (nil)"
        end
      end

      private

      def error(msg)
        puts "Autoscale::Agent/WorkerDispatcher[#{@id}][ERROR]: #{msg}"
      end
    end
  end
end
