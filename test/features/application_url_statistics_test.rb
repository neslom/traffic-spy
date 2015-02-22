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
      post '/sources/google/data', 'payload={"url":"http://google.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":87,"referredBy":"http://google.com","requestType":"POST","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'
      post '/sources/google/data', 'payload={"url":"http://google.com/blog","requestedAt":"2013-02-15 21:38:28 -0700","respondedIn":37,"referredBy":"http://google.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'
      post '/sources/google/data', 'payload={"url":"http://google.com/blog/2","requestedAt":"2012-02-15 21:38:28 -0700","respondedIn":99,"referredBy":"http://google.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'
    end

    def test_returns_error_if_url_does_not_exist
      visit '/sources/google/urls/blub'
      assert page.has_content?("ERROR")
    end

    def test_client_can_navigate_to_url_specific_page
      visit '/sources/google/urls/blog'
      within("h3") do
        assert page.has_content?("http://google.com/blog Statistics")
      end
    end

    def test_can_return_longest_response_time
      visit '/sources/google/urls/blog'
      within("#url_response_times") do
        assert page.has_content?(87)
        assert page.has_content?(/longest|Longest/)
      end
    end

    def test_can_return_shortest_response_time
      visit '/sources/google/urls/blog'
      within("#url_response_times") do
        assert page.has_content?(/shortest|Shortest/)
        assert page.has_content?(37)
      end
    end

    def test_shows_average_response_time
      visit '/sources/google/urls/blog'
      within("#url_response_times") do
        assert page.has_content?(/average|Average/)
        assert page.has_content?(37)
      end
    end

    def test_shows_error_for_url_with_additional_path
      visit '/sources/google/urls/blog/1'
      assert page.has_content?("ERROR")
    end

    def test_shows_data_for_url_with_additional_path
      visit '/sources/google/urls/blog/2'

      within("h3") do
        assert page.has_content?("http://google.com/blog/2 Statistics")
      end

      within("#url_response_times") do
        assert page.has_content?(99)
      end
    end

    def test_shows_which_http_verbs_have_been_used
      visit '/sources/google/urls/blog'
      within("#http_verbs") do
        assert page.has_content?("POST")
      end
    end

    def test_most_popular_referred_by
      visit '/sources/google/urls/blog'
      within("#most_reffered_by") do
        assert page.has_content?("http://google.com")
      end
    end

    def test_most_popular_user_agents
      visit '/sources/google/urls/blog'
      within("#most_popular_user_agents") do
        assert page.has_content?("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17")
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
