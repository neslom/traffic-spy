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
        x = Serialize.new(payload)
        url = x.create_url
        referral = x.create_referral
        request = x.create_request
        event = x.create_event
        user_agent = x.create_user_agent
        resolution = x.create_resolution
        user = User.find_by(identifier: params[:identifier])
        payload[:parameters] = payload[:parameters].to_s
        if Payload.find_by({user_id: user.id, url_id: url.id, requestedAt: payload[:requestedAt], respondedIn: payload[:respondedIn], referral_id: referral.id, request_id: request.id, parameters: payload[:parameters], event_id: event.id, user_agent_id: user_agent.id, resolution_id: resolution.id, ip: payload[:ip]})
          status 403
          body "FORBIDDEN: Payload has already been received"
        else
          Payload.create({user_id: user.id, url_id: url.id, requestedAt: payload[:requestedAt], respondedIn: payload[:respondedIn], referral_id: referral.id, request_id: request.id, parameters: payload[:parameters], event_id: event.id, user_agent_id: user_agent.id, resolution_id: resolution.id, ip: payload[:ip]})
        end
      end
    end

    get '/sources/:identifier' do
      user = User.find_by(identifier: params[:identifier])
      if !user
        erb :error
      else
        urls = user.payloads.map { |x| x.url.url }
        @sorted_urls = urls.sort_by { |e| urls.count(e) }.reverse.uniq
        erb :index
      end
    end
  end
end
