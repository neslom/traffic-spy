module TrafficSpy
  class Serialize
    attr_reader :payload

    def initialize(payload)
      @payload = payload
    end

    def create_url
      Url.find_or_create_by({url: payload[:url]})
    end

    def create_referral
      Referral.find_or_create_by({referredBy: payload[:referredBy]})
    end

    def create_request
      Request.find_or_create_by({requestType: payload[:requestType]})
    end

    def create_event
      Event.find_or_create_by({eventName: payload[:eventName]})
    end

    def create_user_agent
      UserAgent.find_or_create_by({userAgent: payload[:userAgent]})
    end

    def create_resolution
      Resolution.find_or_create_by({resolutionWidth: payload[:resolutionWidth], resolutionHeight: payload[:resolutionHeight]})
    end

    def payload_has_already_been_received?
      Payload.find_by({user_id: user.id, url_id: url.id, requestedAt: payload[:requestedAt], respondedIn: payload[:respondedIn], referral_id: referral.id, request_id: request.id, parameters: payload[:parameters], event_id: event.id, user_agent_id: useragent.id, resolution_id: resolution.id, ip: payload[:ip]})
    end

    def create_payload
      Payload.create({user_id: user.id, url_id: url.id, requestedAt: payload[:requestedAt], respondedIn: payload[:respondedIn], referral_id: referral.id, request_id: request.id, parameters: payload[:parameters], event_id: event.id, user_agent_id: useragent.id, resolution_id: resolution.id, ip: payload[:ip]})
    end
  end
end
