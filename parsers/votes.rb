require 'json'
require 'net/http'
require_relative '../models'

class VoteParser
  def self.url(datetime)
    "http://www.govtrack.us/api/v2/vote/?congress=113&chamber=house&session=2013&limit=599&created__gt=#{datetime}"
  end

  def self.fetch_since(datetime)
    response = Net::HTTP.get(URI(self.url(datetime)))
    votes = JSON.parse(response)['objects']

    return if votes.empty?

    votes.each do |gt_vote|
      next if Vote.get(gt_vote['id']) # skip if we have the vote for whatever reason

      vote = Vote.create_from_gt_vote(gt_vote)
      vote.save!

      vote_data = Net::HTTP.get(URI("http://www.govtrack.us/api/v2/vote_voter/?limit=599&vote=#{vote.id}"))
      gt_voter_votes = JSON.parse(vote_data)['objects']

      missing_reps = []
      gt_voter_votes.map do |voter_vote|
        if Legislator.count(id: voter_vote['person']['id']) > 0
          vv = VoterVote.create({
            id: voter_vote['id'],
            voted_on: voter_vote['created'],
            legislator_id: voter_vote['person']['id'],
            vote_id: voter_vote['vote']['id'],
            option_id: voter_vote['option']['id'],
            option_key: voter_vote['option']['key'],
            option_value: voter_vote['option']['value']
          })
          vv.save
        else
          missing_reps.push voter_vote['person']['id']
        end
      end

      puts "parsed #{gt_voter_votes.length} voter_votes"
      puts "missing: "
      puts missing_reps.inspect
    end

    true
  end

end



