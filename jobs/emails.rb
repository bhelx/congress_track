require 'erb'
require_relative '../email'
require_relative '../models'

votes = Vote.all
plain_template = ERB.new(IO.read('./views/emails/report.erb'))
html_template = ERB.new(IO.read('./views/html_emails/report.erb'))

User.active.each do |user|

  # find votes that user has yet to see
  unseen_votes = votes.select do |vote|
    vote.created_at > user.last_email
  end

  next if unseen_votes.empty?

  # find the voter_votes that this user cares about
  voter_votes = unseen_votes.map do |vote|
    vote.voter_votes.select do |vv|
      user.legislators.include? vv.legislator
    end
  end.flatten

  # create some reports for each vote
  report = {}
  voter_votes.each do |voter_vote|
    report[voter_vote.vote] ||= []
    report[voter_vote.vote].push voter_vote
  end

  # send the mail and update the user object if it worked
  begin
    if user.use_html_email
      Pony.mail to: user.email,
                from: "Congress Track <noreply@congresstrack.org>",
                subject: "Latest Votes",
                headers: { 'Content-Type' => 'text/html' },
                body: html_template.result(binding)
    else
      Pony.mail to: user.email,
                from: "Congress Track <noreply@congresstrack.org>",
                subject: "Latest Votes",
                body: template.result(binding)
    end

    user.last_email = DateTime.now
    user.save!
  rescue => e
    puts e
  end

end
