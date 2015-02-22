require './test/test_helper'

module TrafficSpy
  class ApplicationUrlStatisticsTest < MiniTest::Test
    include Rack::Test::Methods
    include Capybara::DSL

    def app
      TrafficSpy::Server
    end

    def teardown
      DatabaseCleaner.clean
    end

    def test_the_dashboard_can_be_visited
      visit '/'
      assert page.has_content?("Welcome to Traffic Spy!")
    end
  end
end
