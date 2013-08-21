require 'pony'
require 'erb'
require_relative '../models'

votes = Vote.all
template = ERB.new(IO.read('./views/email.erb'))

User.each do |user|
  voter_votes = []
  votes.each do |vote|
    vvs = vote.voter_votes.select do |vv|
      user.legislators.include? vv.legislator
    end

    voter_votes.concat vvs
  end

  report = {}
  voter_votes.each do |voter_vote|
    report[voter_vote.vote] ||= []
    report[voter_vote.vote].push voter_vote
  end

  Pony.mail to: user.email,
            from: "derp@email.com",
            subject: "Votes",
            body: template.result(binding)

end

