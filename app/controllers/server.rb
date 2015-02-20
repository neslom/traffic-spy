require 'json'

module TrafficSpy
  class Server < Sinatra::Base
    get '/' do
      erb :index
    end

    not_found do
      erb :error
    end

    post '/sources' do
      user = User.new(params)
      if user.save
        "{\"identifier\":\"#{params[:identifier]}\"}"
      else
        if user.errors.full_messages.join.include?("blank")
          status 400
          body user.errors.full_messages
        elsif user.errors.full_messages.join.include?("taken")
          status 403
          body user.errors.full_messages
        end
      end
    end

    post '/sources/:identifier/data' do
     if params[:payload].nil? || params[:payload].empty?
       status 400
       body "Missing payload"
     elsif !User.find_by(identifier: params[:identifier])
      status 403
      body "User not registered"
    else
      payload = JSON.parse(params[:payload]).symbolize_keys
      url= Url.find_or_create_by({url: payload[:url]})
      referral = Referral.find_or_create_by({referredBy: payload[:referredBy]})
      request = Request.find_or_create_by({requestType: payload[:requestType]})
      event = Event.find_or_create_by({eventName: payload[:eventName]})
      useragent = UserAgent.find_or_create_by({userAgent: payload[:userAgent]})
      resolution = Resolution.find_or_create_by({resolutionWidth: payload[:resolutionWidth], resolutionHeight: payload[:resolutionHeight]})
      user = User.find_by(identifier: params[:identifier])
      payload[:parameters] = payload[:parameters].to_s
      # Payload.find_or_create_by({user_id: user.id, url_id: url.id, requestedAt: payload[:requestedAt], respondedIn: payload[:respondedIn], referral_id: referral.id, request_id: request.id, parameters: payload[:parameters], event_id: event.id, user_agent_id: useragent.id, resolution_id: resolution.id, ip: payload[:ip]})
        if Payload.find_by({user_id: user.id, url_id: url.id, requestedAt: payload[:requestedAt], respondedIn: payload[:respondedIn], referral_id: referral.id, request_id: request.id, parameters: payload[:parameters], event_id: event.id, user_agent_id: useragent.id, resolution_id: resolution.id, ip: payload[:ip]})
          status 403
          body "FORBIDDEN: Payload has already been recieved"
        else
          Payload.create({user_id: user.id, url_id: url.id, requestedAt: payload[:requestedAt], respondedIn: payload[:respondedIn], referral_id: referral.id, request_id: request.id, parameters: "", event_id: event.id, user_agent_id: useragent.id, resolution_id: resolution.id, ip: payload[:ip]})
        end
      end

    end
  end
end
