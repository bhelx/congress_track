require 'sinatra'
require 'pony'

if settings.development?
  require "letter_opener"
  Pony.options = {
    :via => LetterOpener::DeliveryMethod,
    :via_options => {:location => File.expand_path('../tmp/letter_opener', __FILE__)}
  }
else
  Pony.options = {
    :via => :smtp,
    :via_options => {
      :address => 'smtp.sendgrid.net',
      :port => '587',
      :domain => 'heroku.com',
      :user_name => ENV['SENDGRID_USERNAME'],
      :password => ENV['SENDGRID_PASSWORD'],
      :authentication => :plain,
      :enable_starttls_auto => true
    }
  }
end
