#!/usr/bin/env bash
set -o errexit

bundle install
npm install --legacy-peer-deps

# SECRET_KEY_BASE needed during asset precompilation
export SECRET_KEY_BASE=${SECRET_KEY_BASE:-$(ruby -rsecurerandom -e 'puts SecureRandom.hex(64)')}

# Precompile assets WITHOUT database connection (not needed for assets)
DATABASE_URL="" bundle exec rake assets:precompile

# Database setup (needs real DATABASE_URL)
bundle exec rake db:migrate 2>/dev/null || bundle exec rake db:setup
