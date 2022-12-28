module Autoscale
  module Agent
    class Railtie < ::Rails::Railtie
      initializer "autoscale.add_middleware" do |app|
        app.config.middleware.insert 0, Autoscale::Agent::Middleware
      end
    end
  end
end
