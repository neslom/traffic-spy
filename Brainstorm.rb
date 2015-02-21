Traffic Spy:

Simulation Engine --> Sends HHTP data via a payload

Traffic Spy intercepts the payload via a Rack


Parts of Traffic Spy:

1: Application Registration
  -Two Parameters come in:
    -Identifier: -i:(include headers)...this is the unique id for user that they enter
    -RootURL: -d:(data, sends specified data in post request) this is the root url of their site
  -Must validate this user ID is unique, and the url exists
  -Three possible error codes:
    -400: Missing parameters (send back our error message)
    -403: Forbidden if id already exists (send back our message)
    -200: Shit is cool man
2: Processing requests
  -Post request by sim engine
  -Payload data sent via a JSON
  -T spy must extract, analyze, and store data in databases
  -Must validate that this payload is unique
    -400: If the payload is missing return status 400 Bad Request with a descriptive error message.
    -403: Already Received Request: Forbidden. If the request payload has already been received return status 403 Forbidden with a descriptive error message.
    -403: Application Not Registered: Forbidden. When data is submitted to an application URL that does not exist, return a 403 Forbidden with a descriptive error message.
    -200: Shit is cool man

Our TSpy user interface

Viewing data/stats

3: Application details
  -A client is able to view aggregate site data at the following address:
    -http://UltimateTrafficSpy:port/sources/IDENTIFIER
  -When an identifer exists return a page that displays the following:
    -Validate it exists
    -Most requested to least requested URL
    -web browser breakdown
    -OS breakdown
    -Resolution
    -URL response time sorted by most to least
    -Hyperlinks to each URL to view url specific data
    -Hyperlinks to view aggregate event data

4: APP URL Stats
  -A client is able to view URL specific data at the following address:
    -http://UltimateTrafficSpy:port/sources/IDENTIFIER/urls/RELATIVE/PATH
  -Examples:
    -http://UltimateTrafficSpy:port/sources/jumpstartlab/urls/blog
    -http://UltimateTrafficSpy:port/sources/jumpstartlab/urls/article/1
    -http://UltimateTrafficSpy:port/sources/jumpstartlab/urls/about
  -When the url for the identifier does exists:
    -Validate it exists
    -Longest response time
    -Shortest response time
    -Average response time
    -Which HTTP verbs have been used
    -Most popular referrrers
    -Most popular user agents
  -When the url for the identifier does not exist:
    -Message that the url has not been requested


5:Application Events Index
  -A client is able to view aggregate event data at the following address:
    -http://UltimateTrafficSpy:port/sources/IDENTIFIER/events
  -When events have been defined:
    -Most received event to least received event
    -Hyperlinks of each event to view event specific data

6:Application Event Details
  -A client is able to view event specific data at the following address:
  -http://UltimateTrafficSpy:port/sources/IDENTIFIER/events/EVENTNAME
  -Examples:
    -http://UltimateTrafficSpy:port/sources/jumpstartlab/events/startedRegistration
    -http://UltimateTrafficSpy:port/sources/jumpstartlab/events/addedSocialThroughPromptA
    -http://UltimateTrafficSpy:port/sources/jumpstartlab/events/addedSocialThroughPromptB
  -When the event has been defined:
    -Hour by hour breakdown of when the event was received. How many were shown at noon? at 1pm? at 2pm? Do it for all 24 hours.
    -How many times it was recieved overall
  -When the event has not been defined:
    -Message that no event with the given name has been defined
    -Hyperlink to the Application Events Index

----

Parts of our html webpage:
  -Dashboard/index/sources --> insert an identifier
  -Validate that this identifier exists
  -Data homepage for that identifier
  -Hyperlinks on this page for each seperate url
    -Most requested to least requested URLs
    -Web browser breakdow
    -OS breakdown
    -Resolution
    -URL response time recorded by url
    -Links on these pages back to the aggregate data homepage

URLS needed in Sinatra
1: Http://UltimateTrafficSpy:port/sources
2: Http://UltimateTrafficSpy:port/sources/IDENTIFIER/data
3: Http://UltimateTrafficSpy:port/sources/IDENTIFIER
5:-http://UltimateTrafficSpy:port/sources/IDENTIFIER/urls/blog
6:-http://UltimateTrafficSpy:port/sources/IDENTIFIER/urls/article/1
7:-http://UltimateTrafficSpy:port/sources/IDENTIFIER/urls/about
8:-http://UltimateTrafficSpy:port/sources/IDENTIFIER/events
9:-http://UltimateTrafficSpy:port/sources/IDENTIFIER/events/startedRegistration
10:-http://UltimateTrafficSpy:port/sources/IDENTIFIER/events/addedSocialThroughPromptA
11:-http://UltimateTrafficSpy:port/sources/IDENTIFIER/events/addedSocialThroughPromptB

curl -i -d 'payload={"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}' http://localhost:9393/sources/jumpstartlab/data
curl -i -d 'payload={"url":"http://jumpstartlab.com/about","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}' http://localhost:9393/sources/jumpstartlab/data
curl -i -d 'payload={"url":"http://jumpstartlab.com/contact","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}' http://localhost:9393/sources/jumpstartlab/data
curl -i -d 'payload={"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}' http://localhost:9393/sources/jumpstartlab/data
curl -i -d 'payload={"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}' http://localhost:9393/sources/jumpstartlab/data
curl -i -d 'payload={"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}' http://localhost:9393/sources/jumpstartlab/data
