$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "simplecov"
SimpleCov.start

require "autoscale/agent"
require "minitest/autorun"
require "minitest/unit"
require "mocha/minitest"
require "webmock/minitest"
require "timecop"

class Autoscale::Agent::TestBase < Minitest::Test
  def setup
    Autoscale::Agent::Configuration.run = false
    Timecop.travel Time.utc(2000)
  end
end
