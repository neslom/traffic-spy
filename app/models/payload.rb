module TrafficSpy
  class Payload < ActiveRecord::Base
    belongs_to :url
    belongs_to :user
    belongs_to :referral
    belongs_to :request
    belongs_to :resolution
    belongs_to :event
    belongs_to :user_agent
  end
end
