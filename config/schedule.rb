env :GEM_PATH, '/usr/local/bundle/'
set :output, 'log/cron.log'
set :bundle_command, '/usr/local/bundle/bin/bundle exec'

every 1.day, at: ['09:30 am'] do
  rake 'crawler:execute'
end
