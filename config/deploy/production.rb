ip = '185.119.57.244'

server ip, user: 'deploy', roles: %w(web app db)

set :stage, 'production'
set :rails_env, 'production'
