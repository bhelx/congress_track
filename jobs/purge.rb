require 'date'
require_relative '../models'

threshold = Date.today - 3 # last 3 days

puts VoterVote.all(:voted_on.lt => threshold).destroy
