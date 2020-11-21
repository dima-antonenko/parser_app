ip = '185.104.114.243'

server ip, user: 'deploy', roles: %w(web app db)

set :stage, 'production'
set :rails_env, 'production'
