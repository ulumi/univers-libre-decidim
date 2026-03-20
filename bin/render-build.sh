#!/usr/bin/env bash
set -o errexit

bundle install
npm install --legacy-peer-deps

# Build assets
bundle exec rake assets:precompile

# Database setup
bundle exec rake db:migrate 2>/dev/null || bundle exec rake db:setup
