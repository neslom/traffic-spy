module TrafficSpy
  class Payload < ActiveRecord::Base
    belongs_to :urls
    belongs_to :users
    belongs_to :referrals
    belongs_to :requests
    belongs_to :resolutions
    belongs_to :events
    belongs_to :user_agents
  end
end
