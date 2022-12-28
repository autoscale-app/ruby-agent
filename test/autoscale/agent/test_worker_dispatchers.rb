require "test_helper"

class Autoscale::Agent::TestWorkerDispatchers < Autoscale::Agent::TestBase
  TOKEN = "u4quBFgM72qun74EwashWv6Ll5TzhBVktVmicoWoXla"

  def test_dispatch
    dispatchers = Autoscale::Agent::WorkerDispatchers.new
    dispatchers << Autoscale::Agent::WorkerDispatcher.new(TOKEN)
    dispatchers.each { |dispatcher| dispatcher.expects(:dispatch) }
    dispatchers.dispatch
  end

  def test_dispatch_exception
    dispatchers = Autoscale::Agent::WorkerDispatchers.new
    dispatchers << Autoscale::Agent::WorkerDispatcher.new(TOKEN)
    dispatchers.each { |dispatcher| dispatcher.expects(:dispatch).raises }
    out, _ = capture_io { dispatchers.dispatch }
    assert_match "Autoscale::Agent/WorkerDispatcher: RuntimeError", out.chomp
  end
end
