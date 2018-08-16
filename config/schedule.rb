env :GEM_PATH, "/usr/local/bundle/"
set :output, 'log/cron.log'
set :bundle_command, "/usr/local/bundle/bin/bundle exec"

every 1.day, at: ['09:30 am', '5:30 pm'] do
  rake "crawler:execute"
end
