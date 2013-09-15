require 'sinatra'
require 'data_mapper'
require 'securerandom'

if settings.development?
  DataMapper.setup :default, "sqlite://#{Dir.pwd}/database.db"
else
  DataMapper.setup(:default, ENV['HEROKU_POSTGRESQL_BRONZE_URL'])
end

class Legislator
  include DataMapper::Resource

  property :id            , Integer , key: true
  property :party         , String
  property :first_name    , String
  property :last_name     , String
  property :middle_name   , String
  property :role          , String
  property :state         , String

  has n, :voter_votes
  has n, :trackings
  has n, :users, through: :trackings
end

class Vote
  include DataMapper::Resource

  property :created_at, DateTime, default: DateTime.now
  property :id, Integer, key: true
  property :question, String
  property :question_details, String
  property :result, String
  property :total_minus, Integer
  property :total_plus, Integer
  property :total_other, Integer
  property :link, String

  has n, :voter_votes

  def self.create_from_gt_vote(gt_vote)
    properties = Vote.properties.map(&:name)
    self.new(gt_vote.select { |k, v| { k: v } if properties.include? k.to_sym })
  end

end

class VoterVote
  include DataMapper::Resource

  property :id, Integer , key: true
  property :option_id, Integer
  property :option_key, String
  property :option_value, String
  property :voted_on, DateTime

  belongs_to :vote
  belongs_to :legislator

end

class User
  include DataMapper::Resource

  property :id, Serial
  property :email, String, unique: true
  property :zip, String
  property :confirmed, Boolean, default: false
  property :subscribed, Boolean, default: true
  property :created_at, DateTime, default: DateTime.now
  property :last_email, DateTime, default: DateTime.now # start tracking now, ignore everything before
  property :access_token, String, default: lambda { |p, r| SecureRandom.urlsafe_base64(32) }

  has n, :trackings
  has n, :legislators, through: :trackings

  def self.active
    all(confirmed: true, subscribed: true)
  end

end

class Tracking
  include DataMapper::Resource

  property :id, Serial

  belongs_to :user,       key: true
  belongs_to :legislator, key: true
end

DataMapper.auto_upgrade!

