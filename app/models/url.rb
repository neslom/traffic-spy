module TrafficSpy
  class Url < ActiveRecord::Base
    has_many :payloads
  end
end
