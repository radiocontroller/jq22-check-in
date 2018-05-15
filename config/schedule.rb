env :PATH, ENV['PATH']
env :GEM_PATH, "/usr/local/bundle/"
set :output, 'log/cron.log'
set :bundle_command, "/usr/local/bundle/bin/bundle exec"
every 1.day, at: ['10:00 am', '6:00 pm'] do
  rake "crawler:execute"
end
