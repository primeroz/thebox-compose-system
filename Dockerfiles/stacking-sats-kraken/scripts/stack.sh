#!/bin/bash
#set -e

# hide deprecation warning
export NODE_OPTIONS="--no-deprecation"

# All other settings come from ENVs

if [[ "${KRAKEN_DRY_RUN_PLACE_NO_ORDER}" ]]; then
  result=$(npm run test:stack --silent 2>&1)
  rc=$?
else
  result=$(npm run stack --silent 2>&1)
  rc=$?
fi
echo "$result"

title="StackSats Success"
if [[ "$rc" -ne 0 ]]; then
  title="StackSats Failure"
fi

simplepush -k "${SP_ID}" -m "${result}" -t "${title}" -e stacksats -p "${SP_PASSWORD}" -s "${SP_SALT}"
