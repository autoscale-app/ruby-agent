require "uri"
require "net/https"
require "multi_json"

require_relative "agent/configuration"
require_relative "agent/middleware"
require_relative "agent/request"
require_relative "agent/version"
require_relative "agent/web_dispatcher"
require_relative "agent/web_dispatchers"
require_relative "agent/worker_dispatcher"
require_relative "agent/worker_dispatchers"
require_relative "agent/worker_server"
require_relative "agent/worker_servers"

module Autoscale
  module Agent
    module_function

    def configure(&block)
      @configuration = Configuration.new(&block)
    end

    def configuration
      @configuration
    end
  end
end

require_relative "agent/railtie" if defined?(Rails::Railtie)
