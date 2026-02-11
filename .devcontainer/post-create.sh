#!/usr/bin/env bash
# Exit immediately if a command exits with a non-zero status
set -e

# Change to the 'docs' directory
cd docs

# Configure Bundler to install gems locally in the 'vendor/bundle' directory
bundle config set --local path 'vendor/bundle'

# Install Ruby gems specified in the Gemfile
bundle install

# Install the Netlify CLI globally using npm
npm install -g netlify-cli

# Netlify 23.15.1 on ARM fails to install a working version of deno,
# so install the latest one directly.
# Note: this should not be necessary once netlify is fixed
npm install -g deno

# Return to the previous directory
cd ..
