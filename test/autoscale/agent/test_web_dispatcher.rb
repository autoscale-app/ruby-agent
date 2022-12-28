require "test_helper"

class Autoscale::Agent::TestWebDispatcher < Autoscale::Agent::TestBase
  TOKEN = "u4quBFgM72qun74EwashWv6Ll5TzhBVktVmicoWoXla"

  def test_id
    dispatcher = Autoscale::Agent::WebDispatcher.new(TOKEN) { 1.23 }
    assert_equal "u4quBFg", dispatcher.instance_variable_get(:@id)
  end

  def test_dispatch
    request =
      stub_request(:post, "https://metrics.autoscale.app/")
        .with(
          body: '{"946684801":1,"946684802":2,"946684803":3,"946684804":4,"946684805":5,"946684806":6}',
          headers: {
            "Autoscale-Metric-Token" => "u4quBFgM72qun74EwashWv6Ll5TzhBVktVmicoWoXla",
            "Content-Type" => "application/json",
            "User-Agent" => "Autoscale Agent (Ruby)"
          }
        )
        .to_return(status: 200, body: "", headers: {})
    dispatcher = Autoscale::Agent::WebDispatcher.new(TOKEN)
    [[1], [0, 2, 1], [2, 1, 3], [1, 4, 3], [5, 4, 1], [6, 2, 6], [0, 3, 7]].each do |metrics|
      Timecop.travel(1)
      metrics.each { |metric| dispatcher.add(metric) }
    end
    dispatcher.dispatch
    assert_requested request
  end

  def test_dispatch_empty
    Autoscale::Agent::WebDispatcher.new(TOKEN).dispatch
  end

  def test_dispatch_500
    request =
      stub_request(:post, "https://metrics.autoscale.app/")
        .to_return(status: 500, body: "", headers: {})
    dispatcher = Autoscale::Agent::WebDispatcher.new(TOKEN)
    [[1], [0, 2, 1], [2, 1, 3], [1, 4, 3], [5, 4, 1], [6, 2, 6], [0, 3, 7]].each do |metrics|
      Timecop.travel(1)
      metrics.each { |metric| dispatcher.add(metric) }
    end
    buffer = dispatcher.instance_variable_get(:@buffer).clone
    out, _ = capture_io { dispatcher.dispatch }
    assert_requested request
    assert_match "Autoscale::Agent/WebDispatcher[u4quBFg][ERROR]: Failed to dispatch (500) ", out.chomp
    assert_equal buffer, dispatcher.instance_variable_get(:@buffer).clone
  end

  def test_prune
    dispatcher = Autoscale::Agent::WebDispatcher.new(TOKEN)
    Timecop.travel(-61)
    dispatcher.add(1)
    Timecop.travel(Time.utc(2000))
    dispatcher.add(2)
    buffer = dispatcher.instance_variable_get(:@buffer)
    assert_equal ({946684739 => 1, 946684800 => 2}), buffer
    dispatcher.prune
    assert_equal ({946684800 => 2}), buffer
  end
end
