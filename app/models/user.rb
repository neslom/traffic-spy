module TrafficSpy
  class User < ActiveRecord::Base
    validates :identifier, uniqueness: true, presence: true
    validates :rootUrl, presence: true
  end
end
