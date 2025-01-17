#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f tmp/pids/server.pid

# Wait for PostgreSQL to be ready
until pg_isready -h "$POSTGRES_HOST" -U "$POSTGRES_USER"; do
  echo "Waiting for PostgreSQL..."
  sleep 2
done

# Check if the database exists
DB_EXISTS=$(PGPASSWORD=$POSTGRES_PASSWORD psql -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -tAc "SELECT 1 FROM pg_database WHERE datname='$POSTGRES_DB'" || true)

if [ "$DB_EXISTS" != "1" ]; then
  echo "Database does not exist. Setting up the database..."
  bundle exec rails db:create
  bundle exec rails db:migrate
  bundle exec rails db:seed
else
  echo "Database already exists. Skipping setup."
  # Optionally, run migrations to ensure the schema is up to date
  bundle exec rails db:migrate
fi

# Execute the container's main process (CMD from Dockerfile)
exec "$@"
