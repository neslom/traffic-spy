require './test/test_helper'

module TrafficSpy
  class UserAgentTest < MiniTest::Test
    def teardown
      DatabaseCleaner.clean
    end

    def test_can_create_user_agent_entry
      user_agent = UserAgent.new(userAgent: "Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17")
      assert user_agent.valid?
    end

    def test_will_not_create_a_duplicate_user_agent
      UserAgent.find_or_create_by(userAgent: "Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17")
      UserAgent.find_or_create_by(userAgent: "Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17")
      assert_equal 1, UserAgent.count
    end

    def test_creates_multiple_user_agents
      UserAgent.find_or_create_by(userAgent: "Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17")
      UserAgent.find_or_create_by(userAgent: "Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Dhrome/24.0.1309.0 Safari/537.17")
      assert_equal 2, UserAgent.count
    end
  end
end
