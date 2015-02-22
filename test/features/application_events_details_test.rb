require './test/test_helper'

module TrafficSpy
  class ApplicationEventDetailsTest < MiniTest::Test
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

    def test_it_can_view_a_details_page
      visit '/sources/jumpstartlab/events'
      click_link_or_button("socialLogin")
      assert '/sources/jumpstartlab/events/socialLogin', current_path
      assert page.has_content?("Event Detail")
    end
  end
end

# Application Event Details
#
# A client is able to view event specific data at the following address:
#
# http://yourapplication:port/sources/IDENTIFIER/events/EVENTNAME
#
# Examples:
#
# http://yourapplication:port/sources/jumpstartlab/events/startedRegistration
# http://yourapplication:port/sources/jumpstartlab/events/addedSocialThroughPromptA
# http://yourapplication:port/sources/jumpstartlab/events/addedSocialThroughPromptB
#
# When the event has been defined:
#
#     Hour by hour breakdown of when the event was received. How many were shown at noon? at 1pm? at 2pm? Do it for all 24 hours.
#     How many times it was recieved overall
#
# When the event has not been defined:
#
#     Message that no event with the given name has been defined
#     Hyperlink to the Application Events Index
