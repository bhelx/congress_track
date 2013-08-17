require 'sinatra'
require 'json'
require_relative './sunlight_api'

get '/' do
  erb :index
end

get '/legislators/:zip' do
  SunlightApi.legislators_locate(params[:zip]).to_json
end


