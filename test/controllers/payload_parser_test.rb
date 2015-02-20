require './test/test_helper'

module TrafficSpy
class PayloadParserTest < MiniTest::Test
  include Rack::Test::Methods

  def app
    TrafficSpy::Server
  end

  def teardown
    DatabaseCleaner.clean
  end

  def test_correctly_assigns_id_for_full_payload

    
  end

end
end