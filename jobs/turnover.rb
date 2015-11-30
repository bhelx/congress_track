# To be run on congress turnover

require './sunlight_api'
require './models'

User.active.each do |user|
  puts "User: #{user.email}"

  response = SunlightApi.legislators_locate(user.zip)
  new_ids = response['results'].map { |l| l['govtrack_id'].to_i }.sort
  current_ids = user.trackings.map { |t| t.legislator.id }.sort

  if new_ids.empty?
    puts response
    puts "Skpping, resp empty"
    next
  end

  if new_ids == current_ids
    puts "Skipping"
    next
  end

  # delete all
  user.trackings.destroy

  new_ids.each do |legislator_id|
    legislator = Legislator.get(legislator_id)
    if legislator
      puts "Adding #{legislator.full_name_and_designation} #{legislator_id}"
      tracking = Tracking.new legislator: Legislator.get(legislator_id), user: user
      tracking.save!
    end
  end

  puts "Trackings #{user.trackings.count}"
end
