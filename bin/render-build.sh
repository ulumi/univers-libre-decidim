#!/usr/bin/env bash
set -o errexit

bundle install
npm install --legacy-peer-deps

export SECRET_KEY_BASE=${SECRET_KEY_BASE:-$(ruby -rsecurerandom -e 'puts SecureRandom.hex(64)')}
ORIG_DATABASE_URL="$DATABASE_URL"
export DATABASE_URL="postgresql://dummy:dummy@localhost/dummy"

# Capture full error output
echo "=== STARTING ASSET PRECOMPILE ==="
bundle exec rake assets:precompile 2>/tmp/build_error.log || {
  echo "=== ERROR MESSAGE ==="
  cat /tmp/build_error.log | head -5
  echo "=== END ERROR ==="
  cat /tmp/build_error.log | tail -50
  exit 1
}

export DATABASE_URL="$ORIG_DATABASE_URL"
bundle exec rake db:migrate 2>/dev/null || bundle exec rake db:setup
