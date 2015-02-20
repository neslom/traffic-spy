require './test/test_helper'

module TrafficSpy
  class PayloadSerializationTest < MiniTest::Test
    include Rack::Test::Methods

    def app
      TrafficSpy::Server
    end

    def teardown
      DatabaseCleaner.clean
    end

    def test_accepts_complete_curl
      post '/sources/jumpstartlab/data', 'payload={"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'
      assert_equal 1, Payload.count
    end
  end
end
