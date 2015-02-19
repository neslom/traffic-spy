require './test/test_helper'

module TrafficSpy
  class RequestTest < MiniTest::Test
    def teardown
      DatabaseCleaner.clean
    end

    def test_can_create_referral_entry
      request = Request.new(requestType: "GET")
      assert request.valid?
    end

    def test_will_not_create_a_duplicate_request
      Request.find_or_create_by(requestType: "GET")
      Request.find_or_create_by(requestType: "GET")
      assert_equal 1, Request.count
    end

    def test_creates_multiple_requests
      Request.find_or_create_by(requestType: "GET")
      Request.find_or_create_by(requestType: "PUT")
      assert_equal 2, Request.count
    end
  end
end
