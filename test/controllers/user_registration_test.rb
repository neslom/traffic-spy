require './test/test_helper'

class UserRegistrationTest < MiniTest::Test
  include Rack::Test::Methods

  def app
    TrafficSpy::Server
  end

  def teardown
    DatabaseCleaner.clean
  end

  def test_can_create_user
    post '/sources', { identifier: "jumpstartlab", rootUrl: "http://jumpstartlab.com" }
    assert_equal 1, TrafficSpy::User.count
    assert_equal 200, last_response.status
    assert_equal "{\"identifier\":\"jumpstartlab\"}", last_response.body
  end

  def test_cannot_create_user_with_blank_input_for_identifier
    post '/sources', { identifier: "", rootUrl: "http://jumpstartlab.com" }
    assert_equal 0, TrafficSpy::User.count
    assert_equal 400, last_response.status
    assert_equal "Identifier can't be blank", last_response.body
  end

  def test_cannot_create_user_without_identifier
    post '/sources', { rootUrl: "http://jumpstartlab.com" }
    assert_equal 0, TrafficSpy::User.count
    assert_equal "Identifier can't be blank", last_response.body
    assert_equal 400, last_response.status
  end

  def test_cannot_create_user_without_root_url
    post '/sources', { identifier: "http://jumpstartlab.com" }
    assert_equal 0, TrafficSpy::User.count
    assert_equal "Rooturl can't be blank", last_response.body
    assert_equal 400, last_response.status
  end

  def test_cannot_create_user_that_already_exist
    post '/sources', { identifier: "jumpstartlab", rootUrl: "http://jumpstartlab.com" }
    post '/sources', { identifier: "jumpstartlab", rootUrl: "http://jumpstartlab.com" }
    assert_equal 1, TrafficSpy::User.count
    assert_equal "Identifier has already been taken", last_response.body
    assert_equal 403, last_response.status
  end
end
