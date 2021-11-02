#!/bin/bash
set -e

# Setup env vars required by `./go ft`
export ENV="CI"
export TESTS="$TESTS"

echo "📦  Install cypress  ..."
yarn cypress install > /dev/null

# Run ft
./go ft:"$TESTS"
