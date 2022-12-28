require "test_helper"

class Autoscale::Agent::TestWorkerServer < Autoscale::Agent::TestBase
  TOKEN = "u4quBFgM72qun74EwashWv6Ll5TzhBVktVmicoWoXla"

  def test_serve
    server = Autoscale::Agent::WorkerServer.new(TOKEN) { 1.23 }
    assert_equal 1.23, server.serve
  end
end
