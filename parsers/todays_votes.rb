require 'json'
require 'net/http'
require_relative '../models'

url = "http://www.govtrack.us/api/v2/vote/?congress=113&chamber=house&session=2013&created__gt=2013-07-06&limit=599"

@votes = JSON.parse(Net::HTTP.get(URI(url)))['objects']

@votes.each do |gt_vote|
  next if Vote.get(gt_vote['id'])
  vote = Vote.create_from_gt_vote(gt_vote)
  vote.save!
  puts vote

  gt_voter_votes = JSON.parse(Net::HTTP.get(URI("http://www.govtrack.us/api/v2/vote_voter/?limit=599&vote=#{vote['id']}")))['objects']
  gt_voter_votes.map do |voter_vote|
    vv = VoterVote.create({
      id: voter_vote['id'],
      legislator_id: voter_vote['person']['id'],
      vote_id: voter_vote['vote']['id'],
      option_id: voter_vote['option']['id'],
      option_key: voter_vote['option']['key'],
      option_value: voter_vote['option']['value']
    })
    vv.save!
    puts vv
  end

end

