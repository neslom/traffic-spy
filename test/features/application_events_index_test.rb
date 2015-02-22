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

    def test_it_displays_the_header
      visit '/sources/jumpstartlab/events'
      assert page.has_content?("Event Index")
      refute page.has_content?("Wackado")
    end

    def test_it_displays_the_events_for_identifier
      visit '/sources/jumpstartlab/events'
      assert page.has_content?("socialLogin")
      refute page.has_content?("mouseclick")
      post '/sources', 'identifier=jumpstartlab&rootUrl=http://jumpstartlab.com'
      post '/sources/jumpstartlab/data', 'payload={"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":[],"eventName": "mouseclick","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'
      visit '/sources/jumpstartlab/events'
      assert page.has_content?("mouseclick")

    end

    def test_it_has_links_for_the_events
      visit '/sources/jumpstartlab/events'
      assert page.find_link("socialLogin")
    end

    def test_the_links_take_to_event_detail_page
      visit '/sources/jumpstartlab/events'
      assert page.find_link("socialLogin")
      click_link_or_button("socialLogin")
      assert "/sources/jumpstartlab/events/socialLogin", current_path
    end

    def test_it_routes_to_error_page_with_custom_message_when_identified_has_no_events
      post '/sources', 'identifier=paulgrever&rootUrl=http://paulgrever.com'
      post '/sources/paulgrever/data', 'payload={"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":[],"userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'
      visit '/sources/paulgrever'
      click_link_or_button("Event Details")
      assert '/sources/paulgrever/events', current_path
      assert page.has_content?("ERROR")
      within ("#custom_error_message") do 
        assert page.has_content?("No events have been defined for this user")
      end
    end
  end
end

# require './test/test_helper'
#  include Capybara::DSL

# Application Events Index
#
# A client is able to view aggregate event data at the following address:
#
# http://yourapplication:port/sources/IDENTIFIER/events
#
# When events have been defined:
#
#     Most received event to least received event
#     Hyperlinks of each event to view event specific data
#
# When no events have been defined:
#
#     Message that no events have been defined
