#!/bin/bash

# testrunner.sh - Simple test runner for fmtlog

set -euo pipefail

FMTLOG_SCRIPT="$(dirname "$0")/fmtlog"
INPUT='{"level":"info","ts":"2025-09-01T21:33:02+07:00","msg":"Server is shutting down...","resource":{"service.name":"time_off_service","service.env":"local"}}'

# Test case: Run fmtlog with piped input (valid JSON)
RAW_OUTPUT=$(echo "$INPUT" | "$FMTLOG_SCRIPT")
LINE_COUNT=$(echo "$RAW_OUTPUT" | wc -l | tr -d ' ')
EXPECTED_LINE_COUNT=9
if [ "$LINE_COUNT" -eq "$EXPECTED_LINE_COUNT" ]; then
  echo "PASS: Output has $EXPECTED_LINE_COUNT lines as expected."
else
  echo "FAIL: Output does not have $EXPECTED_LINE_COUNT lines."
  echo "Actual line count: $LINE_COUNT" >&2
  echo "Output was:" >&2
  echo "$RAW_OUTPUT" >&2
  exit 1
fi

# Test case: non-JSON input line
NON_JSON_INPUT='this is not json'
# Capture both stdout and stderr
NON_JSON_RESULT=$(mktemp)
NON_JSON_ERR=$(mktemp)
echo "$NON_JSON_INPUT" | "$FMTLOG_SCRIPT" > "$NON_JSON_RESULT" 2> "$NON_JSON_ERR"
NON_JSON_ACTUAL=$(cat "$NON_JSON_RESULT")
NON_JSON_WARNING=$(cat "$NON_JSON_ERR")
rm -f "$NON_JSON_RESULT" "$NON_JSON_ERR"


# Test case: Check line count for non-JSON output
NON_JSON_LINE_COUNT=$(echo "$NON_JSON_ACTUAL" | wc -l | tr -d ' ')
EXPECTED_NON_JSON_LINE_COUNT=1
if [ "$NON_JSON_LINE_COUNT" -eq "$EXPECTED_NON_JSON_LINE_COUNT" ]; then
  echo "PASS: Non-JSON input output has $EXPECTED_NON_JSON_LINE_COUNT line as expected."
else
  echo "FAIL: Non-JSON input output does not have $EXPECTED_NON_JSON_LINE_COUNT line." >&2
  echo "Actual line count: $NON_JSON_LINE_COUNT" >&2
  echo "Output was:" >&2
  echo "$NON_JSON_ACTUAL" >&2
  exit 1
fi

# Restore EXPECTED_WARNING for warning check
EXPECTED_WARNING="Failed to transform: 767: unexpected token at 'this is not json'"

# Check for warning in stderr
if echo "$NON_JSON_WARNING" | grep -q "$EXPECTED_WARNING"; then
  echo "PASS: Warning for non-JSON input is present."
else
  echo "FAIL: Warning for non-JSON input is missing or incorrect." >&2
  echo "Expected warning: $EXPECTED_WARNING" >&2
  echo "Actual warning: $NON_JSON_WARNING" >&2
  exit 1
fi
