
desc "syncs our legislator data and database entries"
task :legislators do
  sh "rsync -avz govtrack.us::govtrackdata/congress-legislators data/"
  ruby "parsers/members.rb"
end

desc "sends emails"
task :emails do
  ruby "jobs/emails.rb"
end

desc "parses latest votes"
task :votes do
  ruby "jobs/votes.rb"
end

desc "Pull up a pry console with access to models"
task :console do
  sh "pry -r./models.rb"
end

