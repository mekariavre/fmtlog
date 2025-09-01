#!/bin/bash

# testrunner.sh - Simple test runner for fmtlog

set -euo pipefail

FMTLOG_SCRIPT="$(dirname "$0")/fmtlog"
INPUT='{"level":"info","ts":"2025-09-01T21:33:02+07:00","msg":"Server is shutting down...","resource":{"service.name":"time_off_service","service.env":"local"}}'
EXPECTED_OUTPUT=$(echo "$INPUT" | jq --color-output .)

# Run fmtlog with piped input (valid JSON)
ACTUAL_OUTPUT=$(echo "$INPUT" | "$FMTLOG_SCRIPT")

if [ "$ACTUAL_OUTPUT" = "$EXPECTED_OUTPUT" ]; then
  echo "PASS: Output matches expected JSON."
else
  echo "FAIL: Output does not match expected JSON."
  echo "Expected:" >&2
  echo "$EXPECTED_OUTPUT" >&2
  echo "Actual:" >&2
  echo "$ACTUAL_OUTPUT" >&2
  exit 1
fi

# Test case: non-JSON input line
NON_JSON_INPUT='this is not json'
NON_JSON_EXPECTED="$NON_JSON_INPUT"
# Capture both stdout and stderr
NON_JSON_RESULT=$(mktemp)
NON_JSON_ERR=$(mktemp)
echo "$NON_JSON_INPUT" | "$FMTLOG_SCRIPT" > "$NON_JSON_RESULT" 2> "$NON_JSON_ERR"
NON_JSON_ACTUAL=$(cat "$NON_JSON_RESULT")
NON_JSON_WARNING=$(cat "$NON_JSON_ERR")
rm -f "$NON_JSON_RESULT" "$NON_JSON_ERR"

EXPECTED_WARNING="Failed to transform: 767: unexpected token at 'this is not json'"

if [ "$NON_JSON_ACTUAL" = "$NON_JSON_EXPECTED" ]; then
  echo "PASS: Non-JSON input is output unchanged."
else
  echo "FAIL: Non-JSON input is not output unchanged." >&2
  echo "Expected: $NON_JSON_EXPECTED" >&2
  echo "Actual: $NON_JSON_ACTUAL" >&2
  exit 1
fi

# Check for warning in stderr
if echo "$NON_JSON_WARNING" | grep -q "$EXPECTED_WARNING"; then
  echo "PASS: Warning for non-JSON input is present."
else
  echo "FAIL: Warning for non-JSON input is missing or incorrect." >&2
  echo "Expected warning: $EXPECTED_WARNING" >&2
  echo "Actual warning: $NON_JSON_WARNING" >&2
  exit 1
fi
