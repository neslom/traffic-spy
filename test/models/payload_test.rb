require './test/test_helper'

module TrafficSpy
  class PayloadTest < MiniTest::Test
    def teardown
      DatabaseCleaner.clean
    end
    # Unit Testing for Paylod
    def test_it_can_create_payload_entry
      payload = Payload.new(user_id: 1, url_id: 2, requestedAt: "2013-02-16 21:38:28 -0700", respondedIn: 37, referral_id: 1, request_id: 3, paramaters: "fill", event_id: 1, user_agent_id: 1, resolution_id: 2, ip: "63.29.38.211")
      assert payload.valid?
    end

    def test_it_adds_to_db
      Payload.create(user_id: 1, url_id: 2, requestedAt: "2013-02-16 21:38:28 -0700", respondedIn: 37, referral_id: 1, request_id: 3, paramaters: "fill", event_id: 1, user_agent_id: 1, resolution_id: 2, ip: "63.29.38.211")
      assert_equal 1, Payload.count
    end

    def test_it_will_not_create_a_duplicate
      Payload.find_or_create_by(user_id: 1, url_id: 2, requestedAt: "2013-02-16 21:38:28 -0700", respondedIn: 37, referral_id: 1, request_id: 3, paramaters: "fill", event_id: 1, user_agent_id: 1, resolution_id: 2, ip: "63.29.38.211")
      Payload.find_or_create_by(user_id: 1, url_id: 2, requestedAt: "2013-02-16 21:38:28 -0700", respondedIn: 37, referral_id: 1, request_id: 3, paramaters: "fill", event_id: 1, user_agent_id: 1, resolution_id: 2, ip: "63.29.38.211")
      assert_equal 1, Payload.count
    end

    def test_creates_multiple_payload
      Payload.find_or_create_by(user_id: 1, url_id: 2, requestedAt: "2013-02-16 21:38:28 -0700", respondedIn: 37, referral_id: 1, request_id: 3, paramaters: "fill", event_id: 1, user_agent_id: 1, resolution_id: 2, ip: "63.29.38.211")
      Payload.find_or_create_by(user_id: 2, url_id: 2, requestedAt: "2013-02-16 21:38:28 -0700", respondedIn: 40, referral_id: 1, request_id: 4, paramaters: "fill", event_id: 1, user_agent_id: 1, resolution_id: 2, ip: "63.29.38.211")
      assert_equal 2, Payload.count   
    end

    
    
  end
end
