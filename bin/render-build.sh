#!/usr/bin/env bash
set -o errexit

# Install gems
bundle install

# Precompile assets
bin/rails assets:precompile
bin/rails assets:clean

# Prepare DB (creates DB if missing, runs migrations if needed)
bin/rails db:prepare

# Conditionally seed data
if [[ "$RUN_SEED" == "true" ]]; then
  echo "Seeding production database..."
  bin/rails db:seed
else
  echo "Skipping seeds for production."
fi

# Ensure migrations are applied (if using prepare, this is optional)
bin/rails db:migrate
