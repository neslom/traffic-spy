# require './test/test_helper'
#  include Capybara::DSL
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
