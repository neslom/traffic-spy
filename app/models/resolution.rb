module TrafficSpy
  class Resolution < ActiveRecord::Base
    has_many :payloads
  end
end
