require 'yaml'
require_relative '../models'

members = YAML.load_file('./data/congress-legislators/legislators-current.yaml')

# extract the latest contact form or nil if there aren't any
def latest_contact_form(terms)
  t = terms.reverse.detect { |term| term['contact_form'] }
  t['contact_form'] if t
end

# extract the latest site or nil if there aren't any
def latest_site(terms)
  t = terms.reverse.detect { |term| term['site'] }
  t['site'] if t
end

members.each do |member|

  legislator = {
    id: member['id']['govtrack'],
    party: member['terms'].last['party'],
    first_name: member['name']['first'],
    last_name: member['name']['last'],
    middle_name: member['name']['middle'],
    role: member['terms'].last['type'],
    state: member['terms'].last['state'],
    contact_form: latest_contact_form(member['terms']),
    site: latest_site(member['terms'])
  }

  if persisted = Legislator.get(member['id']['govtrack'])
    persisted.update legislator
  else
    Legislator.create(legislator).save!
  end
end

