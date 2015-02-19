require './test/test_helper'

module TrafficSpy
  class UserTest < MiniTest::Test
    def teardown
      DatabaseCleaner.clean
    end

    def test_valid_with_unique_identifier_and_rooturl
      user = User.new(identifier: "jumpstartlab", rootUrl: "hweoaw;eofiawofhawef")
      assert user.valid?
    end

    def test_is_not_valid_with_duplicate_identifier
      User.create(identifier: "jumpstartlab", rootUrl: "hweoaw;eofiawofhawef")
      user = User.new(identifier: "jumpstartlab", rootUrl: "hweoaw;eofiawofhawef")
      refute user.valid?
    end

    def test_invalid_if_missing_identifier
      user = User.new(rootUrl: "hweoaw;eofiawofhawef")
      refute user.valid?
    end

    def test_invalid_if_missing_root_url
      user = User.new(identifier: "jumpstartlab")
      refute user.valid?
    end
  end
end
