require 'yaml'
require_relative '../models'

members = YAML.load_file('./data/congress-legislators/legislators-current.yaml')

members.each do |member|
  next if Legislator.get(member['id']['govtrack'])

  legislator = {
    id: member['id']['govtrack'],
    party: member['terms'].last['party'],
    first_name: member['name']['first'],
    last_name: member['name']['last'],
    middle_name: member['name']['middle'],
    role: member['terms'].last['type'],
    state: member['terms'].last['state']
  }

  Legislator.create(legislator).save!
end

