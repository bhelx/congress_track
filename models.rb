require 'data_mapper'

DataMapper.setup :default, "sqlite://#{Dir.pwd}/database.db"

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
end

class Vote
  include DataMapper::Resource

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
    puts gt_vote
    properties = Vote.properties.map(&:name)
    puts gt_vote.select { |k, v| { k: v } if properties.include? k }
    self.new(gt_vote.select { |k, v| { k: v } if properties.include? k })
  end

end

class VoterVote
  include DataMapper::Resource

  property :id, Integer , key: true
  property :option_id, Integer
  property :option_key, String
  property :option_value, String

  belongs_to :vote
  belongs_to :legislator
end

DataMapper.auto_upgrade!

