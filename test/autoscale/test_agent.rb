require "test_helper"

class Autoscale::TestAgent < Autoscale::Agent::TestBase
  def test_version
    refute_nil ::Autoscale::Agent::VERSION
  end
end
