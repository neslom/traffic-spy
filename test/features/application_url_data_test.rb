# require './test/test_helper'
#  include Capybara::DSL


# A client is able to view URL specific data at the following address:
#
# http://yourapplication:port/sources/IDENTIFIER/urls/RELATIVE/PATH
#
# http://yourapplication:port/sources/jumpstartlab/urls/blog
# http://yourapplication:port/sources/jumpstartlab/urls/article/1
# http://yourapplication:port/sources/jumpstartlab/urls/about
#
#
# When the url for the identifier does exists:
#
#     Longest response time
#     Shortest response time
#     Average response time
#     Which HTTP verbs have been used
#     Most popular referrrers
#     Most popular user agents
#
# When the url for the identifier does not exist:
#
#     Message that the url has not been requested
