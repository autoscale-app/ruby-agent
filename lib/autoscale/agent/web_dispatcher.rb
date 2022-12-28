module Autoscale
  module Agent
    class WebDispatcher
      TTL = 30

      attr_reader :token

      def initialize(token)
        @id = token.each_char.take(7).join
        @token = token
        @buffer = {}
        @mutex = Mutex.new
      end

      def add(value, timestamp: Time.now.to_i)
        @mutex.synchronize do
          @buffer[timestamp] ||= 0
          @buffer[timestamp] = value if value > @buffer[timestamp]
        end
      end

      def prune
        @mutex.synchronize do
          max_age = Time.now.to_i - TTL
          @buffer.delete_if { |timestamp, _| timestamp < max_age }
        end
      end

      def dispatch
        return unless (payload = build_payload)

        body = MultiJson.dump(payload)
        response = Request.dispatch(body, token: token)

        unless response.is_a?(Net::HTTPOK)
          revert_payload(payload)
          error "Failed to dispatch (#{response.code}) #{response.body}"
        end
      end

      private

      def build_payload
        @mutex.synchronize do
          now = Time.now.to_i
          keys = @buffer.each_key.select { |key| key < now }
          payload = @buffer.slice(*keys)
          keys.each { |key| @buffer.delete(key) }
          payload if payload.any?
        end
      end

      def revert_payload(payload)
        payload.each do |timestamp, value|
          add(value, timestamp: timestamp)
        end
      end

      def error(msg)
        puts "Autoscale::Agent/WebDispatcher[#{@id}][ERROR]: #{msg}"
      end
    end
  end
end
