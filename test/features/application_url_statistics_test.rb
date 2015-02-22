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

    def setup
      post '/sources', 'identifier=google&rootUrl=http://google.com'
      post '/sources/google/data', 'payload={"url":"http://google.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://google.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'
      post '/sources/google/data', 'payload={"url":"http://google.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":87,"referredBy":"http://google.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'
      post '/sources/google/data', 'payload={"url":"http://google.com/blog","requestedAt":"2013-02-15 21:38:28 -0700","respondedIn":37,"referredBy":"http://google.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'
    end

    def test_returns_error_if_url_does_not_exist
      visit '/sources/google/urls/blub'
      assert page.has_content?("ERROR")
    end

    def test_client_can_navigate_to_url_specific_page
      visit '/sources/google/urls/blog'
      within("h3") do
        assert page.has_content?("google/blog Statistics")
      end
    end

    def test_can_return_longest_response_time
      visit '/sources/google/urls/blog'
      within("ul") do
        assert page.has_content?(87)
        assert page.has_content?(/longest|Longest/)
      end
    end

    def test_can_return_shortest_response_time
      visit '/sources/google/urls/blog'
      within("ul") do
        assert page.has_content?(/shortest|Shortest/)
        assert page.has_content?(37)
      end
    end

    def test_shows_average_response_time
      visit '/sources/google/urls/blog'
      within("ul") do
        assert page.has_content?(/average|Average/)
        assert page.has_content?(37)
      end
    end

  end
end
# A client is able to view URL specific data at the following address:
#
# http://yourapplication:port/sources/IDENTIFIER/urls/RELATIVE/PATH
#
# http://yourapplication:port/sources/google/urls/blog
# http://yourapplication:port/sources/google/urls/article/1
# http://yourapplication:port/sources/google/urls/about
#
#
# When the url for the identifier does exists:
#
#     Longest response time
#     Shortest response time
#     Average response time
#     Which HTTP verbs have been used
#     Most popular referrrers (most popular reffered_by)
#     Most popular user agents
#
# When the url for the identifier does not exist:
#
#     Message that the url has not been requested
