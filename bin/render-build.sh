#!/usr/bin/env bash
set -o errexit

bundle install
npm install --legacy-peer-deps

export SECRET_KEY_BASE=${SECRET_KEY_BASE:-$(ruby -rsecurerandom -e 'puts SecureRandom.hex(64)')}

# Precompile assets (no DB needed)
bundle exec rake assets:precompile

# Database setup
bundle exec rake db:migrate 2>/dev/null || bundle exec rake db:setup
