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

# Return to the previous directory
cd ..
