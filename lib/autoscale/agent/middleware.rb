# frozen_string_literal: true

module Autoscale
  module Agent
    class Middleware
      def initialize(app)
        @app = app
      end

      def call(env)
        return serve(env) if env["PATH_INFO"] == "/autoscale"
        record_queue_time(env)
        @app.call(env)
      end

      private

      def serve(env)
        tokens = (env["HTTP_AUTOSCALE_METRIC_TOKENS"] || "").split(",")
        server = Autoscale::Agent.configuration.worker_servers.find(tokens)
        return [404, {}, ["Not Found"]] unless server
        headers = {
          "content-type" => "application/json",
          "cache-control" => "must-revalidate, private, max-age=0"
        }
        [200, headers, [MultiJson.dump(server.serve)]]
      end

      def record_queue_time(env)
        return unless request_start_header(env)
        return unless (dispatcher = Autoscale::Agent.configuration.web_dispatchers.queue_time)
        current_time = (Time.now.to_f * 1000).to_i
        request_start_time = to_ms(request_start_header(env))
        elapsed_ms = current_time - request_start_time
        elapsed = (elapsed_ms < 0) ? 0 : elapsed_ms
        dispatcher.add(elapsed)
      end

      def request_start_header(env)
        (env["HTTP_X_REQUEST_START"] || env["HTTP_X_QUEUE_START"]).to_i
      end

      def to_ms(start)
        case Autoscale::Agent.configuration.platform
        when :render
          (start / 1000).to_i
        end
      end
    end
  end
end
