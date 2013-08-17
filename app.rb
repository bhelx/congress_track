require 'sinatra'
require 'json'
require 'coffee-script'
require_relative './sunlight_api'

get '/application.js' do
  coffee :application
end

get '/' do
  erb :index
end

get '/legislators/:zip' do
  SunlightApi.legislators_locate(params[:zip]).to_json
end


