module TrafficSpy
  class Referral < ActiveRecord::Base
    has_many :payloads
  end
end
