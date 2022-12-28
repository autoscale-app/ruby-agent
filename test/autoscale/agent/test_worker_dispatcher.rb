require "test_helper"

class Autoscale::Agent::TestWorkerDispatcher < Autoscale::Agent::TestBase
  TOKEN = "u4quBFgM72qun74EwashWv6Ll5TzhBVktVmicoWoXla"

  def test_id
    dispatcher = Autoscale::Agent::WorkerDispatcher.new(TOKEN) { 1.23 }
    assert_equal "u4quBFg", dispatcher.instance_variable_get(:@id)
  end

  def test_dispatch
    request =
      stub_request(:post, "https://metrics.autoscale.app/")
        .with(
          body: "{\"946684800\":1.23}",
          headers: {
            "Autoscale-Metric-Token" => "u4quBFgM72qun74EwashWv6Ll5TzhBVktVmicoWoXla",
            "Content-Type" => "application/json",
            "User-Agent" => "Autoscale Agent (Ruby)"
          }
        )
        .to_return(status: 200, body: "", headers: {})
    Autoscale::Agent::WorkerDispatcher.new(TOKEN) { 1.23 }.dispatch
    assert_requested request
  end

  def test_dispatch_500
    request = stub_request(:post, "https://metrics.autoscale.app/")
      .with(
        body: "{\"946684800\":1.23}",
        headers: {
          "Autoscale-Metric-Token" => "u4quBFgM72qun74EwashWv6Ll5TzhBVktVmicoWoXla",
          "Content-Type" => "application/json",
          "User-Agent" => "Autoscale Agent (Ruby)"
        }
      )
      .to_return(status: 500, body: "", headers: {})
    out, _ = capture_io do
      Autoscale::Agent::WorkerDispatcher.new(TOKEN) { 1.23 }.dispatch
    end
    assert_requested request
    assert_equal "Autoscale::Agent/WorkerDispatcher[u4quBFg][ERROR]: Failed to dispatch (500) ", out.chomp
  end

  def test_dispatch_nil_value
    out, _ = capture_io do
      Autoscale::Agent::WorkerDispatcher.new(TOKEN) { nil }.dispatch
    end
    assert_equal "Autoscale::Agent/WorkerDispatcher[u4quBFg][ERROR]: Failed to calculate worker information (nil)", out.chomp
  end
end
