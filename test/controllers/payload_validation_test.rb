require './test/test_helper'

class PayloadValidationTest < MiniTest::Test
  include Rack::Test::Methods

  def app
    TrafficSpy::Server
  end

  def teardown
    DatabaseCleaner.clean
  end

  def test_empty_payload_returns_error
    post '/sources/jumpstartlab/data', ""
    assert_equal 400, last_response.status
    assert_equal "Missing payload", last_response.body
  end

  def test_non_existent_payload_returns_error
    post '/sources/jumpstartlab/data'
    assert_equal 400, last_response.status
    assert_equal "Missing payload", last_response.body
  end

  def test_returns_error_if_user_doesnt_exists
    TrafficSpy::User.create(identifier: "jumpstartlab", rootUrl: "http://jumpstartlab.com")
    post '/sources/turingschool/data', 'payload={"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'
    assert_equal 403, last_response.status
    assert_equal "User not registered", last_response.body
  end
end
