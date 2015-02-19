require './test/test_helper'

module TrafficSpy
  class ResolutionTest < MiniTest::Test
    def teardown
      DatabaseCleaner.clean
    end

    def test_can_create_resolution_entry
      resolution = Resolution.new(resolutionWidth: "1920", resolutionHeight: "1280")
      assert resolution.valid?
    end

    def test_will_not_create_a_duplicate_resolution
      Resolution.find_or_create_by(resolutionWidth: "1920", resolutionHeight: "1280")
      Resolution.find_or_create_by(resolutionWidth: "1920", resolutionHeight: "1280")
      assert_equal 1, Resolution.count
    end

    def test_creates_multiple_resolutions
      Resolution.find_or_create_by(resolutionWidth: "1920", resolutionHeight: "1280")
      Resolution.find_or_create_by(resolutionWidth: "800", resolutionHeight: "640")
      assert_equal 2, Resolution.count
    end
  end
end
