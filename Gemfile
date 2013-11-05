# A sample Gemfile
source "https://rubygems.org"

ruby '1.9.3'

gem "rake"
gem "sinatra"
gem "data_mapper"
gem "coffee-script"
gem "sass"
gem "therubyracer", :platform => :ruby
gem "pony"

group :production do
  gem "dm-postgres-adapter"
  gem "unicorn"
end

group :development do
  gem "dm-sqlite-adapter"
  gem "pry"
  gem "foreman"
end
