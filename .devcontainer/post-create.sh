#!/usr/bin/env bash
set -e

cd www
bundle config set --local path 'vendor/bundle'
bundle install
npm install -g netlify-cli
cd ..
