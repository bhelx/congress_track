
desc "syncs our legislator data using rsync"
task :sync_legislators do
  sh "rsync -avz govtrack.us::govtrackdata/congress-legislators data/"
end

desc "parses legislator data into database entries"
task :parse_legislators do
  ruby "parsers/members.rb"
end

desc "both sync and parse legislator entries"
task :legislators => ["sync_legislators", "parse_legislators"]

desc "sends emails"
task :emails do
  ruby "jobs/emails.rb"
end

desc "parses latest votes"
task :votes do
  ruby "jobs/votes.rb"
end

desc "Purge old VoterVotes"
task :purge do
  ruby "jobs/purge.rb"
end

desc "parses new votes and sends reports"
task :sync => ["votes", "emails"]

desc "Pull up a pry console with access to models"
task :console do
  sh "pry -r./models.rb"
end

