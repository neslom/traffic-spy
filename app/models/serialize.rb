module TrafficSpy
  class Serialize
    attr_reader :payload

    def initialize(payload)
      @payload = payload
    end

    def call
      find_or_create_url
      find_or_create_referral
      find_or_create_request
      find_or_create_event
      find_or_create_user_agent
      find_or_create_resolution
    end

    def find_or_create_url
      Url.find_or_create_by({url: payload[:url]})
    end

    def find_or_create_referral
      Referral.find_or_create_by({referredBy: payload[:referredBy]})
    end

    def find_or_create_request
      Request.find_or_create_by({requestType: payload[:requestType]})
    end

    def find_or_create_event
      Event.find_or_create_by({eventName: payload[:eventName]})
    end

    def find_or_create_user_agent
      UserAgent.find_or_create_by({userAgent: payload[:userAgent]})
    end

    def find_or_create_resolution
      Resolution.find_or_create_by({resolutionWidth: payload[:resolutionWidth],
                                    resolutionHeight: payload[:resolutionHeight]
                                   })
    end

    def payload_has_already_been_received?(user, payload)
      Payload.find_by({user_id: user.id,
                       url_id: find_or_create_url.id,
                       requestedAt: payload[:requestedAt],
                       respondedIn: payload[:respondedIn],
                       referral_id: find_or_create_referral.id,
                       request_id: find_or_create_request.id,
                       parameters: payload[:parameters],
                       event_id: find_or_create_event.id,
                       user_agent_id: find_or_create_user_agent.id,
                       resolution_id: find_or_create_resolution.id,
                       ip: payload[:ip]})
    end

    def create_payload(user, payload)
      Payload.create({user_id: user.id,
                      url_id: find_or_create_url.id,
                      requestedAt: payload[:requestedAt],
                      respondedIn: payload[:respondedIn],
                      referral_id: find_or_create_referral.id,
                      request_id: find_or_create_request.id,
                      parameters: payload[:parameters],
                      event_id: find_or_create_event.id,
                      user_agent_id: find_or_create_user_agent.id,
                      resolution_id: find_or_create_resolution.id,
                      ip: payload[:ip]})
    end

  end
end
