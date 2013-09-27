require 'date'
require_relative '../models'

threshold = Date.today - 7 # last week

puts VoterVote.all(:voted_on.lt => threshold).destroy
