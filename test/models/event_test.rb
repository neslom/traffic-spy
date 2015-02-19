require './test/test_helper'

module TrafficSpy
  class EventTest < MiniTest::Test
    def teardown
      DatabaseCleaner.clean
    end

    def test_can_create_event_name_entry
      event = Event.new(eventName: "socialLogin")
      assert event.valid?
    end

    def test_will_not_create_a_duplicate_event_name
      Event.find_or_create_by(eventName: "startedRegistration")
      Event.find_or_create_by(eventName: "startedRegistration")
      assert_equal 1, Event.count
    end

    def test_creates_multiple_event_names
      Event.find_or_create_by(eventName: "addedSocialThroughPromptA")
      Event.find_or_create_by(eventName: "addedSocialThroughPromptB")
      assert_equal 2, Event.count
    end
  end
end
