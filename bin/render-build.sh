#!/usr/bin/env bash
set -o errexit

bundle install
npm install --legacy-peer-deps

export SECRET_KEY_BASE=${SECRET_KEY_BASE:-$(ruby -rsecurerandom -e 'puts SecureRandom.hex(64)')}

# Precompile assets
bundle exec rake assets:precompile

# Database migration only (Supabase DB already exists, don't try db:create)
bundle exec rake db:migrate || bundle exec rake db:schema:load db:migrate
