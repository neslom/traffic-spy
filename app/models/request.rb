module TrafficSpy
  class Request < ActiveRecord::Base
    has_many :payloads
  end
end
