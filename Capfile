# Load DSL and Setup Up Stages
require 'capistrano/setup'

# Includes default deployment tasks
require 'capistrano/deploy'

require "capistrano/scm/git"

require 'capistrano/rbenv'
require 'capistrano/bundler'
require 'capistrano/rails'
require 'capistrano/puma'
require 'capistrano/puma/workers'

install_plugin Capistrano::SCM::Git
install_plugin Capistrano::Puma, load_hooks: true

Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
