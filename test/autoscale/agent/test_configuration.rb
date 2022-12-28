require "test_helper"

class Autoscale::Agent::TestConfiguration < Autoscale::Agent::TestBase
  TOKEN = "u4quBFgM72qun74EwashWv6Ll5TzhBVktVmicoWoXla"

  def test_platform
    [:render].each do |p|
      config = Autoscale::Agent::Configuration.new { platform p }
      assert_equal p, config.platform
    end
  end

  def test_platform_missing
    config = Autoscale::Agent::Configuration.new {}
    assert_raises(Autoscale::Agent::Configuration::PlatformMissingError) { config.platform }
  end

  def test_platform_invalid
    assert_raises(Autoscale::Agent::Configuration::InvalidPlatformError) do
      Autoscale::Agent::Configuration.new { platform :who? }
    end
  end

  def test_dispatch_web
    config = Autoscale::Agent::Configuration.new { dispatch TOKEN }
    dispatcher = config.web_dispatchers.queue_time
    assert_instance_of Autoscale::Agent::WebDispatcher, dispatcher
    assert_equal 1, config.web_dispatchers.count
  end

  def test_dispatch_worker
    config = Autoscale::Agent::Configuration.new { dispatch(TOKEN) { 1.23 } }
    dispatcher = config.worker_dispatchers.first
    assert_instance_of Autoscale::Agent::WorkerDispatcher, dispatcher
    assert_equal 1, config.worker_dispatchers.count
  end

  def test_serve_worker
    config = Autoscale::Agent::Configuration.new { serve(TOKEN) { 1.23 } }
    server = config.worker_servers.first
    assert_instance_of Autoscale::Agent::WorkerServer, server
    assert_equal 1, config.worker_servers.count
  end
end
