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
      assert page.has_content?("Error")
    end

    def test_client_can_visit_app_detail_site
      #post '/sources', 'identifier=jumpstartlab&rootUrl=http://jumpstartlab.com'
      #post '/sources/jumpstartlab/data', 'payload={"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'
      visit '/sources/jumpstartlab'
      assert page.has_content?("Traffic Spyer")
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
