require 'json'
require 'uri'
require 'time'

module TrafficSpy
  class Server < Sinatra::Base

    get '/' do
      erb :dashboard
    end

    not_found do
      erb :error
    end

    post '/sources/?' do
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

    post '/sources/:identifier/data/?' do
      if params[:payload].nil? || params[:payload].empty?
        status 400
        body "Missing payload"
      elsif !User.find_by(identifier: params[:identifier])
        status 403
        body "User not registered"
      else
        payload = JSON.parse(params[:payload]).symbolize_keys
        data = Serialize.new(payload)
        data.call
        user = User.find_by(identifier: params[:identifier])
        payload[:parameters] = payload[:parameters].to_s
        if data.payload_has_already_been_received?(user, payload)
          status 403
          body "FORBIDDEN: Payload has already been received"
        else
          data.create_payload(user, payload)
        end
      end
    end

    get '/sources/:identifier/?' do
      user = User.find_by(identifier: params[:identifier])
      if !user
        @message = "#{params[:identifier]} is not yet registered"
        erb :error
      else
        urls = user.payloads.map { |x| x.url.url }
        @sorted_urls = urls.sort_by { |e| urls.count(e) }.reverse.uniq
        user_agents = user.payloads.map { |x| x.user_agent.userAgent }
        sorted_user_agents = user_agents.sort_by { |e| user_agents.count(e) }.reverse.uniq
        @sorted_user_agents = sorted_user_agents.map { |x| UserAgentParser.parse(x) }
        @resolutions = user.payloads.map { |x| x.resolution }.uniq
        @url_response_times = Url.all.map do |name|
        [name.url, user.payloads.where(url_id: name.id).average(:respondedIn).to_i]
        end
        erb :index
      end
    end

    get '/sources/:identifier/urls/:relative/?:path?' do
      user = User.find_by(identifier: params[:identifier])
      @full_url = user.rootUrl + "/" + params[:relative]
      !params[:path] ? @full_url : @full_url = @full_url + "/" + params[:path].to_s
      url = Url.find_by(url: @full_url)
      if url.nil? || !user.payloads.find_by(url_id: url.id)
        @message = "#{@full_url} has not been requested"
        erb :error
      else
        @url = user.payloads.where(url_id: url.id)
        @http_verbs = @url.all.map { |x| x.request.requestType }.uniq
        referrers = @url.all.map { |x| x.referral.referredBy }
        @sorted_referrers = referrers.sort_by { |e| referrers.count(e) }.reverse.uniq
        user_agents = user.payloads.map { |x| x.user_agent.userAgent }
        @sorted_user_agents = user_agents.sort_by { |e| user_agents.count(e) }.reverse.uniq
        erb :_url_statistics
      end
    end

    get '/sources/:identifier/events' do
      user = User.find_by(identifier: params[:identifier])
      events = user.payloads.map { |u_p| u_p.event.eventName }
      @sorted_events = events.sort_by { |ev| events.count(ev) }.reverse.uniq
      if @sorted_events.all?{|x| x.nil?}
        @message = "No events have been defined for this user"
        erb :error
      else
        erb :event_index
      end
    end

    get '/sources/:identifier/events/:eventname' do
      user = User.find_by(identifier: params[:identifier])
      event_ob = Event.find_by(eventName: params[:eventname])
      if event_ob.nil?
        @message = "#{params[:eventname]} is not an event associated with this user <br>
        <a href='/sources/#{params[:identifier]}/events'>Return To Events Index</a>"
        erb :error
      else
        @event_name = event_ob.eventName
        @event_occurances = event_ob.payloads.count {|us| user.payloads.name == params[:identifier]}
        @event_time = event_ob.payloads.where(user_id: user.id ).all.group_by do |hour|
          Time.parse(hour.requestedAt).strftime("%I%p")
        end
      erb :event_detail
    end
    end

  end
end
