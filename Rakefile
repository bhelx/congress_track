
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
task :votes, [:fetch_time] do |t, args|
  ruby "jobs/votes.rb #{args[:fetch_time]}"
end

desc "Purge old VoterVotes"
task :purge do
  ruby "jobs/purge.rb"
end

desc "Send email from given url"
task :url_email, :subject, :url do |t, args|
  ruby "jobs/url_email.rb", args[:subject], args[:url]
end

desc "Turnover script to be run after elections"
task :turnover do
  ruby "jobs/turnover.rb"
end

desc "parses new votes and sends reports"
task :sync => ["votes", "emails"]

desc "Pull up a pry console with access to models"
task :console do
  sh "pry"
end

