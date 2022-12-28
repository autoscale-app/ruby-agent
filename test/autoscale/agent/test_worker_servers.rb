require "test_helper"

class Autoscale::Agent::TestWorkerServers < Autoscale::Agent::TestBase
  TOKEN = "u4quBFgM72qun74EwashWv6Ll5TzhBVktVmicoWoXla"

  def test_find
    servers = Autoscale::Agent::WorkerServers.new
    servers << (server = Autoscale::Agent::WorkerServer.new(TOKEN) { 1.23 })
    assert_equal server, servers.find(["token-a", TOKEN, "token-b"])
  end

  def test_find_nothing
    servers = Autoscale::Agent::WorkerServers.new
    servers << Autoscale::Agent::WorkerServer.new(TOKEN) { 1.23 }
    assert_nil servers.find(["token-a", "token-b"])
  end
end
