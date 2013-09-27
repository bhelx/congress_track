require 'date'
require_relative '../models'

threshold = Date.today - 7 # last week

puts "Deleted: #{VoterVote.all(:voted_on.lt => threshold).count}"
VoterVote.all(:voted_on.lt => threshold).destroy
