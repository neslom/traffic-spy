require './test/test_helper'

class UserTest < MiniTest::Test
  def teardown
    DatabaseCleaner.clean
  end

  def test_valid_with_unique_identifier_and_rooturl
    user = TrafficSpy::User.new(identifier: "jumpstartlab", rootUrl: "hweoaw;eofiawofhawef")
    assert user.valid?
  end

  def test_is_not_valid_with_duplicate_identifier
    TrafficSpy::User.create(identifier: "jumpstartlab", rootUrl: "hweoaw;eofiawofhawef")
    user = TrafficSpy::User.new(identifier: "jumpstartlab", rootUrl: "hweoaw;eofiawofhawef")
    refute user.valid?
  end

  def test_invalid_if_missing_identifier
    user = TrafficSpy::User.new(rootUrl: "hweoaw;eofiawofhawef")
    refute user.valid?
  end
end
