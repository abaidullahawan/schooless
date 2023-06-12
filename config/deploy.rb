# config valid for current version and patch releases of Capistrano
lock "~> 3.17.2"

set :application, "schooless"
set :repo_url, "git@bitbucket.org:mhussain654gmail/schooless.git"
# set :branch, 'main'
set :user, "deploy"

# Deploy to the user's home directory
set :deploy_to, "/home/deploy/#{fetch :application}"

append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', '.bundle', 'public/system', 'public/uploads'

# Only keep the last 5 releases to save disk space
set :keep_releases, 5
