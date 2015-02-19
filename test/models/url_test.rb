require './test/test_helper'

module TrafficSpy
  class UrlTest < MiniTest::Test
    def teardown
      DatabaseCleaner.clean
    end

    def test_can_create_url_entry
      url = Url.new(url: "http://www.jumpstartlabs.com")
      assert url.valid?
    end

    def test_will_create_a_duplicate_url_with_create_method
      Url.create(url: "http://www.jumpstartlabs.com")
      Url.create(url: "http://www.jumpstartlabs.com")
      assert_equal 2, Url.count
    end

    def test_will_not_create_a_duplicate_url_with_find_or_create_by
      Url.find_or_create_by(url: "http://www.jumpstartlabs.com")
      Url.find_or_create_by(url: "http://www.jumpstartlabs.com")
      assert_equal 1, Url.count
    end

    def test_creates_multiple_urls
      Url.find_or_create_by(url: "http://www.jumpstartlabs.com")
      Url.find_or_create_by(url: "http://www.google.com")
      assert_equal 2, Url.count
    end
  end
end
