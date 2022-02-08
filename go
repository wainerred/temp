#!/usr/bin/env bash

function ft:otpcam() {
  CYPRESS_CMD="run --env ENV=$ENV --headless --browser chrome --spec \"cypress/integration/otp_campaign/*\" --tag \"campaign_smoke\"" runCypressTests $@
}

function ft:otpcam2() {
  CYPRESS_CMD="run --env ENV=$ENV --headless --browser chrome --spec \"cypress/integration/otp_campaign_2/*\" --tag \"campaign_rebook\"" runCypressTests $@
}

function runCypressTests(){
  sh -c "$RUN_CMD cypress ${CYPRESS_CMD:-open}"
}

echo "test"
