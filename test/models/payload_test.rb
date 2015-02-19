require './test/test_helper'

module TrafficSpy
  class PayloadTest < MiniTest::Test
    def teardown
      DatabaseCleaner.clean
    end
  end
end
