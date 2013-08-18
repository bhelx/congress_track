require 'sinatra'
require 'json'
require 'coffee-script'

require_relative './models'
require_relative './sunlight_api'

get '/application.js' do
  coffee :application
end

get '/' do
  erb :index
end

post '/' do
  user = User.new params.reject { |k| k == 'legislators' }
  if user.save!
    params['legislators'].each do |legislator_id|
      tracking = Tracking.new legislator: Legislator.get(legislator_id), user: user
      tracking.save!
    end
  end
  "Done!"
end

get '/legislators/:zip' do
  SunlightApi.legislators_locate(params[:zip]).to_json
end


