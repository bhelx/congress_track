require 'sinatra'
require 'json'
require 'coffee-script'
require 'sass'

require_relative './email'
require_relative './models'
require_relative './sunlight_api'

confirmation_email = ERB.new(IO.read('./views/emails/confirmation.erb'))
welcome_email = ERB.new(IO.read('./views/emails/welcome.erb'))

get '/application.js' do
  coffee :application
end

get '/application.css' do
  scss :application, :style => :compressed
end

get '/' do
  erb :index, locals: { user: User.new }
end

post '/' do
  user = User.new params.reject { |k| k == 'legislators' }
  if user.save
    params['legislators'].each do |legislator_id|
      tracking = Tracking.new legislator: Legislator.get(legislator_id), user: user
      tracking.save!
    end

    Pony.mail to: user.email,
              from: "Congress Track <noreply@congresstrack.org>",
              subject: "Confirm your email address with Congress Track",
              body: confirmation_email.result(binding)

    erb :subscribed, locals: { user: user }
  else
    erb :index, locals: { user: user }
  end
end

get '/legislators/:zip' do
  SunlightApi.legislators_locate(params[:zip]).to_json
end


def token_user
  @user ||= begin
              user = User.first access_token: params[:token]
              halt 404, 'invalid token' unless user
              user
            end
end

get '/users/:token/confirm' do
  user = token_user
  user.update confirmed: true

  Pony.mail to: user.email,
            from: "Congress Track <noreply@congresstrack.org>",
            subject: "Welcome to Congress Track",
            body: welcome_email.result(binding)

  erb :confirmed, locals: { user: user }
end

get '/users/:token' do
  erb :user, locals: { user: token_user }
end

post '/users/:token' do
  token_user.update subscribed: params[:subscribed]
  erb :unsubscribed, locals: { user: token_user }
end

get '/users/:token/change-zip' do
  erb :index, locals: { user: token_user }
end

post '/users/:token/change-zip' do
  if token_user.update(zip: params[:zip])
    token_user.trackings.each { |tracking| tracking.destroy }

    params['legislators'].each do |legislator_id|
      tracking = Tracking.new legislator: Legislator.get(legislator_id), user: token_user
      tracking.save!
    end

    erb :user, locals: { user: token_user }
  else
    erb :index, locals: { user: token_user }
  end
end

