module TrafficSpy
  class User < ActiveRecord::Base
    validates :identifier, uniqueness: true, presence: true
    validates :rootUrl, presence: true
    has_many :payloads
  end
end
