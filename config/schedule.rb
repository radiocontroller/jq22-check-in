#env :PATH, ENV['PATH']
env :GEM_PATH, "/usr/local/bundle/"
set :output, 'log/cron.log'
set :bundle_command, "/usr/local/bundle/bin/bundle exec"

require "active_support/all"
Time.zone = 'Beijing'

every 1.day, at: [Time.parse('9:30 am').utc, Time.parse('5:30 pm').utc] do
  rake "crawler:execute"
end
