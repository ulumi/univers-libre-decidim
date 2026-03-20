#!/usr/bin/env bash
set -o errexit

bundle install
npm install --legacy-peer-deps

export SECRET_KEY_BASE=${SECRET_KEY_BASE:-$(ruby -rsecurerandom -e 'puts SecureRandom.hex(64)')}

# Use dummy DB URL for asset precompilation (needs valid format, no actual connection)
ORIG_DATABASE_URL="$DATABASE_URL"
export DATABASE_URL="postgresql://dummy:dummy@localhost/dummy"
bundle exec rake assets:precompile

# Restore real DATABASE_URL for migrations
export DATABASE_URL="$ORIG_DATABASE_URL"
bundle exec rake db:migrate 2>/dev/null || bundle exec rake db:setup
