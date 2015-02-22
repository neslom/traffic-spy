require './test/test_helper'

module TrafficSpy
  class ApplicationDetailsTest < MiniTest::Test
    include Rack::Test::Methods
    include Capybara::DSL

    def app
      TrafficSpy::Server
    end

    def teardown
      DatabaseCleaner.clean
    end

    def setup
      post '/sources', 'identifier=jumpstartlab&rootUrl=http://jumpstartlab.com'
      post '/sources/jumpstartlab/data', 'payload={"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'
    end

    def test_returns_error_view_for_non_registered_client
      visit '/sources/kimjongil'
      assert page.has_content?("ERROR")
    end

    def test_client_can_visit_app_detail_site
      visit '/sources/jumpstartlab'
      assert page.has_content?("Traffic Spyer")
    end

    def test_client_can_view_urls
      visit '/sources/jumpstartlab'
      within("#url_list") do
        assert page.has_content?("http://jumpstartlab.com/blog")
      end
    end

    def test_shows_browser_info
      post '/sources/jumpstartlab/data', 'payload={"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Safari/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'
      visit '/sources/jumpstartlab'
      within("#user_agent_list") do
        assert page.has_content?("Chrome")
        assert page.has_content?("Safari")
      end
    end

    def test_shows_screen_resolution
      post '/sources/jumpstartlab/data', 'payload={"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Safari/24.0.1309.0 Safari/537.17","resolutionWidth":"2000","resolutionHeight":"2000","ip":"63.29.38.211"}'
      visit '/sources/jumpstartlab'
      within("#resolution_list") do
        assert page.has_content?("2000 X 2000")
        assert page.has_content?("1920 X 1280")
      end
    end

    def test_shows_average_response_time_per_url
      visit '/sources/jumpstartlab'
      within("#url_response_time_list") do
        assert page.has_content?("http://jumpstartlab.com/blog: 37 ms")
      end
    end

    def test_hyperlinks_for_url_specific_data
      visit '/sources/jumpstartlab'
      assert page.find_link("http://jumpstartlab.com/blog")
      click_link_or_button("http://jumpstartlab.com/blog")
      assert_equal '/sources/jumpstartlab/urls/blog', current_path
    end

    def test_shows_event_details_button
      visit '/sources/jumpstartlab'
      assert page.find_link("Event Details")
      click_link_or_button("Event Details")
      assert_equal '/sources/jumpstartlab/events', current_path
    end
  end
end
