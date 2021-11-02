#!/bin/bash
set -e

# Setup env vars required by `./go ft`
export ENV="CI"
export API_DB_NAME="otp_test_$(date +"%Y%m%d%H%M%S")"
export API_DB_USERNAME="$DB_USERNAME"
export API_DB_HOST="$DB_HOST"
export API_DB_PASSWORD="$DB_PASSWORD"
export CLASSIX_DB_NAME="classix_test_$(date +"%Y%m%d%H%M%S")"
export CLASSIX_DB_USERNAME="$DB_USERNAME"
export CLASSIX_DB_HOST="$DB_HOST"
export CLASSIX_DB_PASSWORD="$DB_PASSWORD"
export DIGIX_DB_NAME="digix_test_$(date +"%Y%m%d%H%M%S")"
export DIGIX_DB_USERNAME="$DB_USERNAME"
export DIGIX_DB_HOST="$DB_HOST"
export DIGIX_DB_PASSWORD="$DB_PASSWORD"
export DIR_API="../api-src"
export DIR_CLASSIX="../classix"
export DIR_DIGIX="../digix"
export TESTS="$TESTS"

[ "$(ls -A cache/cypress 2> /dev/null)" ] && echo "cache/cypress present" || mkdir -p cache/cypress
[ "$(ls -A cache/yarn 2> /dev/null)" ] && echo "cache/yarn present" || mkdir -p cache/yarn
export CYPRESS_CACHE_FOLDER=$(pwd)/cache/cypress
export YARN_CACHE_FOLDER=$(pwd)/cache/yarn
echo Yarn cache dir `yarn cache dir`

# Install npm deps
echo "📦  Install node dependencies  ..."
yarn cache clean
yarn config set registry https://registry.npmjs.org/

# all tests requires otp api build
echo "📦 Install node dependencies (OTP-API) ..."
cd ./api-src
yarn install --frozen-lockfile --no-progress > /dev/null

# otp and classix tests requires classix build
if [ "$TESTS" = "otpcam" ] || [ "$TESTS" = "classix" ] ; then
  echo "📦 Install node dependencies (OTP-CLASSIX) ..."
  cd ../classix
  yarn install --frozen-lockfile --no-progress > /dev/null
fi

# digix, otpcam2, otpopp and otpcam ui tests requires digix build
if [ "$TESTS" = "digix" ] || [ "$TESTS" = "otpcam2" ] || [ "$TESTS" = "otpopp" ] || [ "$TESTS" = "otpcam" ] ; then
  echo "📦 Install node dependencies (OTP-DIGIX) ..."
  cd ../digix
  yarn install --frozen-lockfile --no-progress > /dev/null
  yarn build
fi

# all tests requires otp client build
echo "📦 Install node dependencies (OTP-CLIENT) ..."
cd ../src
yarn install --frozen-lockfile --no-progress > /dev/null

echo "📦  Install cypress  ..."
yarn cypress install > /dev/null

# Run ft
./go ft:"$TESTS"
