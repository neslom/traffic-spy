require './test/test_helper'

module TrafficSpy
  class ApplicationDetailsTest < MiniTest::Test
    include Rack::Test::Methods

    def app
      TrafficSpy::Server
    end

    def teardown
      DatabaseCleaner.clean
    end

    def test_client_can_visit_app_detail_site
      visit '/sources/jumpstartlab'

    end
    # Application Details
    #
    # A client is able to view aggregate site data at the following address:
    #
    # http://yourapplication:port/sources/IDENTIFIER
    #
    # When an identifer exists return a page that displays the following:
    #
    #     Most requested URLS to least requested URLS (url)
    #     Web browser breakdown across all requests (userAgent)
    #     OS breakdown across all requests (userAgent)
    #     Screen Resolution across all requests (resolutionWidth x resolutionHeight)
    #     Longest, average response time per URL to shortest, average response time per URL
    #     Hyperlinks of each url to view url specific data
    #     Hyperlink to view aggregate event data
    #
    # When an identifier does not exist return a page that displays the following:
    #
    #     Message that the identifier does not exist

  end
end
