require "test_helper"

class Autoscale::Agent::TestWebDispatchers < Autoscale::Agent::TestBase
  TOKEN = "u4quBFgM72qun74EwashWv6Ll5TzhBVktVmicoWoXla"

  def test_already_set_error
    dispatchers = Autoscale::Agent::WebDispatchers.new
    dispatchers.queue_time = Autoscale::Agent::WebDispatcher.new(TOKEN)
    assert_raises(Autoscale::Agent::WebDispatchers::AlreadySetError) do
      dispatchers.queue_time = Autoscale::Agent::WebDispatcher.new(TOKEN)
    end
  end

  def test_prune
    dispatchers = Autoscale::Agent::WebDispatchers.new
    dispatchers.queue_time = Autoscale::Agent::WebDispatcher.new(TOKEN)
    dispatchers.queue_time.expects(:prune)
    dispatchers.prune
  end

  def test_dispatch
    dispatchers = Autoscale::Agent::WebDispatchers.new
    dispatchers.queue_time = Autoscale::Agent::WebDispatcher.new(TOKEN)
    dispatchers.queue_time.expects(:dispatch)
    dispatchers.dispatch
  end

  def test_dispatch_exception
    dispatchers = Autoscale::Agent::WebDispatchers.new
    dispatchers.queue_time = Autoscale::Agent::WebDispatcher.new(TOKEN)
    dispatchers.queue_time.expects(:dispatch).raises
    out, _ = capture_io { dispatchers.dispatch }
    assert_match "Autoscale::Agent/WebDispatcher: RuntimeError", out.chomp
  end
end
