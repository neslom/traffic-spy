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
        #if user.errors.include?(:identifier) || user.errors.include?(:rootUrl)
        if user.errors.full_messages.join.include?("blank")
          status 400
          body user.errors.full_messages
        elsif user.errors.full_messages.join.include?("taken")
          status 403
          body user.errors.full_messages
        end
      end
    end
  end
end
