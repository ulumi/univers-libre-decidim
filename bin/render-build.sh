#!/usr/bin/env bash
set -o errexit

bundle install
npm install --legacy-peer-deps

# SECRET_KEY_BASE needed during asset precompilation
export SECRET_KEY_BASE=${SECRET_KEY_BASE:-$(ruby -rsecurerandom -e 'puts SecureRandom.hex(64)')}

# Build assets with full trace for debugging
bundle exec rake assets:precompile --trace 2>&1 || {
  echo "=== ASSET PRECOMPILE FAILED ==="
  echo "Ruby version: $(ruby -v)"
  echo "Bundler version: $(bundle -v)"
  echo "Checking Decidim load..."
  bundle exec ruby -e "require 'decidim'; puts 'Decidim loaded OK'" 2>&1 || true
  exit 1
}

# Database setup
bundle exec rake db:migrate 2>/dev/null || bundle exec rake db:setup
