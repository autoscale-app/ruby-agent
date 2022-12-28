module Autoscale
  module Agent
    module Request
      module_function

      def dispatch(body, token:)
        url = ENV["AUTOSCALE_METRICS_URL"] || "https://metrics.autoscale.app"

        headers = {
          "User-Agent" => "Autoscale Agent (Ruby)",
          "Content-Type" => "application/json",
          "Autoscale-Metric-Token" => token
        }

        post(url, body, headers)
      end

      def post(url, body, headers = {})
        uri = URI.parse(url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = uri.port == 443
        http.open_timeout = 5
        http.read_timeout = 5
        request = Net::HTTP::Post.new(uri.request_uri)
        headers.each { |key, value| request[key] = value }
        request.body = body
        http.request(request)
      end
    end
  end
end
