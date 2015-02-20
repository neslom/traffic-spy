module TrafficSpy
  class UserAgent < ActiveRecord::Base
    has_many :payloads
  end
end
