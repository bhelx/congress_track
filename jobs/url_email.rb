require 'erb'
require 'open-uri'
require_relative '../email'
require_relative '../models'

subject = ARGV[0]
template = ERB.new(open(ARGV[1]).read)

User.active.each do |user|

  # send the mail and update the user object if it worked
  begin
    Pony.mail to: user.email,
              from: "noreply@congresstrack.org",
              subject: subject,
              body: template.result(binding)

  rescue => e
    puts e
  end

end

