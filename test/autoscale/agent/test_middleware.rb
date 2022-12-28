require "test_helper"

class Autoscale::Agent::TestMiddleware < Autoscale::Agent::TestBase
  TOKEN = "u4quBFgM72qun74EwashWv6Ll5TzhBVktVmicoWoXla"

  class App
    def call(env)
      [200, {}, [""]]
    end
  end

  def call(env = {})
    Autoscale::Agent::Middleware.new(App.new).call(env)
  end

  def test_call_default
    Autoscale::Agent.configure {}
    response = call
    assert_equal [200, {}, [""]], response
  end

  def test_call_serve
    Autoscale::Agent.configure { serve(TOKEN) { 1.23 } }
    response = call(
      "PATH_INFO" => "/autoscale",
      "HTTP_AUTOSCALE_METRIC_TOKENS" => "#{TOKEN},invalid"
    )
    headers = {
      "content-type" => "application/json",
      "cache-control" => "must-revalidate, private, max-age=0"
    }
    assert_equal [200, headers, ["1.23"]], response
  end

  def test_call_serve_404
    Autoscale::Agent.configure { serve(TOKEN) { 1.23 } }
    response = call(
      "PATH_INFO" => "/autoscale",
      "HTTP_AUTOSCALE_METRIC_TOKENS" => "invalid"
    )
    assert_equal [404, {}, ["Not Found"]], response
  end

  def test_call_record_queue_time_on_render
    Autoscale::Agent.configure do
      platform :render
      dispatch TOKEN
    end
    [[0, 500_000], [0, 1_000_000], [1, 1_500_000]].each do |travel, request_start|
      Timecop.travel(travel)
      response = call(
        "PATH_INFO" => "/",
        "HTTP_X_REQUEST_START" => ((Time.now.to_f * 1_000_000).to_i - request_start).to_s
      )
      assert_equal [200, {}, [""]], response
    end
    buffer =
      Autoscale::Agent
        .configuration
        .web_dispatchers
        .queue_time
        .instance_variable_get(:@buffer)
    assert_equal ({946684800 => 1000, 946684801 => 1500}), buffer
  end
end
