module TrafficSpy
  class Event < ActiveRecord::Base
    has_many :payloads
  end
end
