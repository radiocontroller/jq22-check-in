#env :PATH, ENV['PATH']
#env :GEM_PATH, "/usr/local/bundle/"
set :output, 'log/cron.log'
set :bundle_command, "/usr/local/bundle/bin/bundle exec"

require "active_support/all"
Time.zone = 'Beijing'

every 1.day, at: [Time.zone.parse('9:30 am'), Time.zone.parse('6:00 pm')] do
  rake "crawler:execute"
end
