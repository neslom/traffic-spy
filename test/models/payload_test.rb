require './test/test_helper'

module TrafficSpy
  class PayloadTest < MiniTest::Test
    
    def teardown
      DatabaseCleaner.clean
    end

    def setup
      @event = Event.create(eventName: "socialLogin")
      @referral = Referral.create(referredBy: "http://www.jumpstartlabs.com")
      @request = Request.create(requestType: "GET")
      @resolution = Resolution.create(resolutionWidth: "1920", resolutionHeight: "1280")
      @url = Url.create(url: "http://www.jumpstartlabs.com")
      @user_agent = UserAgent.create(userAgent: "Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17")
      @user = User.create(identifier: "jumpstartlab", rootUrl: "hweoaw;eofiawofhawef")
    end

    # Unit Testing for Paylod
    def test_it_can_create_payload_entry
      payload = Payload.new(user_id: @user, url_id: @url, requestedAt: "2013-02-16 21:38:28 -0700", respondedIn: 37, referral_id: @referral, request_id: @request, parameters: "fill",user_agent_id: @user_agent, resolution_id: @resolution, ip: "63.29.38.211")
      assert payload.valid?
    end

    def test_it_adds_to_db
      Payload.create(user_id: @user, url_id: @url, requestedAt: "2013-02-16 21:38:28 -0700", respondedIn: 37, referral_id: @referral, request_id: @request, parameters: "fill",user_agent_id: @user_agent, resolution_id: @resolution, ip: "63.29.38.211")
      assert_equal 1, Payload.count
    end

    def test_it_will_not_create_a_duplicate
      2.times do
      Payload.find_or_create_by(user_id: 1, url_id: 1, requestedAt: "2013-02-16 21:38:28 -0700", respondedIn: 37, referral_id: 1, request_id: 1, parameters: "fill",user_agent_id: 1, resolution_id: 1, ip: "63.29.38.211")
        end
      assert_equal 1, Payload.count
    end

    def test_creates_multiple_payload
      Payload.find_or_create_by(user_id: @user, url_id: @url, requestedAt: "2013-02-16 21:38:28 -0700", respondedIn: 37, referral_id: @referral, request_id: @request, parameters: "fill",user_agent_id: @user_agent, resolution_id: @resolution, ip: "63.29.38.211")
      Payload.find_or_create_by(user_id: 2, url_id: 2, requestedAt: "2013-02-16 21:38:28 -0700", respondedIn: 40, referral_id: 1, request_id: 4, parameters: "fill", event_id: 1, user_agent_id: 1, resolution_id: 2, ip: "63.29.38.211")
      assert_equal 2, Payload.count
    end

    # Integration tests with payloads

    def test_it_can_find_an_event_name_by_payload
      payload = @event.payloads.create(user_id: @user, url_id: @url, requestedAt: "2013-02-16 21:38:28 -0700", respondedIn: 37, referral_id: @referral, request_id: @request, parameters: "fill",user_agent_id: @user_agent, resolution_id: @resolution, ip: "63.29.38.211")
      assert_equal "socialLogin", payload.event.eventName
    end

    def test_it_can_find_an_user_name_by_payload
      payload = @user.payloads.create(url_id: @url, requestedAt: "2013-02-16 21:38:28 -0700", respondedIn: 37, referral_id: @referral, request_id: @request, parameters: "fill", event_id: @event, user_agent_id: @user_agent, resolution_id: @resolution, ip: "63.29.38.211")
      assert_equal "jumpstartlab", payload.user.identifier
    end

    def test_it_can_find_an_url_name_by_payload
      payload = @url.payloads.create(user_id: @user, requestedAt: "2013-02-16 21:38:28 -0700", respondedIn: 37, referral_id: @referral, request_id: @request, parameters: "fill", event_id: @event, user_agent_id: @user_agent, resolution_id: @resolution, ip: "63.29.38.211")
      assert_equal "http://www.jumpstartlabs.com", payload.url.url
    end

    def test_it_can_find_an_request_name_by_payload
      payload = @request.payloads.create(user_id: @user, url_id: @url, requestedAt: "2013-02-16 21:38:28 -0700", respondedIn: 37, referral_id: @referral, parameters: "fill", event_id: @event, user_agent_id: @user_agent, resolution_id: @resolution, ip: "63.29.38.211")
      assert_equal "GET", payload.request.requestType
      assert_equal 1, payload.request.id
    end

    def test_it_can_find_an_user_agent_name_by_payload
      payload = @user_agent.payloads.create(user_id: @user, url_id: @url, requestedAt: "2013-02-16 21:38:28 -0700", respondedIn: 37, referral_id: @referral, request_id: @request, parameters: "fill", event_id: @event, user_agent_id: @user_agent, resolution_id: @resolution, ip: "63.29.38.211")
      assert_equal "Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", payload.user_agent.userAgent
      assert_equal 1, payload.user_agent.id
    end

    def test_it_can_find_an_resolution_agent_name_by_payload
      payload = @resolution.payloads.create(user_id: @user, url_id: @url, requestedAt: "2013-02-16 21:38:28 -0700", respondedIn: 37, referral_id: @referral, request_id: @request, parameters: "fill", event_id: @event, user_agent_id: @user_agent, resolution_id: @resolution, ip: "63.29.38.211")
      assert_equal "1280", payload.resolution.resolutionHeight
      assert_equal "1920", payload.resolution.resolutionWidth
      assert_equal 1, payload.resolution.id
    end

    def test_it_can_find_a_referral_name_by_payload
      payload = @referral.payloads.create(user_id: @user, url_id: @url, requestedAt: "2013-02-16 21:38:28 -0700", respondedIn: 37, referral_id: @referral, request_id: @request, parameters: "fill", event_id: @event, user_agent_id: @user_agent, resolution_id: @resolution, ip: "63.29.38.211")
      assert_equal "http://www.jumpstartlabs.com", payload.referral.referredBy
      assert_equal 1, payload.referral.id
    end

    def test_it_can_find_an_event_name_by_payload_when_there_are_multiple_events
      Payload.create(user_id: @user, url_id: @url, requestedAt: "2013-02-16 21:38:28 -0700", respondedIn: 37, referral_id: @referral, request_id: @request, parameters: "fill",user_agent_id: @user_agent, resolution_id: @resolution, ip: "63.29.38.211")
      Payload.create(user_id: 2, url_id: 2, requestedAt: "2013-02-16 21:38:28 -0700", respondedIn: 40, referral_id: 1, request_id: 4, parameters: "fill", event_id: 2, user_agent_id: 1, resolution_id: 2, ip: "63.29.38.211")
      Event.create(eventName: "antisocialLogin")
      payload = Payload.find_by(event_id: 2)
      assert_equal "antisocialLogin", payload.event.eventName
    end
  end
end
