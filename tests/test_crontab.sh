#!/bin/bash

set -u

SCRIPT="./starter/setup_cron.sh"
CRON_JOB="./starter/cron_job.sh"

passed=0
failed=0

echo "======================================"
echo " Linux Crontab Assignment Tests"
echo "======================================"

# --------------------------------------------------
# Test 1: Check setup script
# --------------------------------------------------

echo
echo "Test 1: Checking setup script"

if [[ -f "$SCRIPT" ]]; then
    echo "PASS: setup_cron.sh exists."
    passed=$((passed + 1))
else
    echo "FAIL: setup_cron.sh does not exist."
    failed=$((failed + 1))
    exit 1
fi

# --------------------------------------------------
# Test 2: Check cron job script
# --------------------------------------------------

echo
echo "Test 2: Checking cron job script"

if [[ -f "$CRON_JOB" ]]; then
    echo "PASS: cron_job.sh exists."
    passed=$((passed + 1))
else
    echo "FAIL: cron_job.sh does not exist."
    failed=$((failed + 1))
fi

chmod +x "$SCRIPT"
chmod +x "$CRON_JOB"

# --------------------------------------------------
# Clear assignment entries from previous attempts
# --------------------------------------------------

CURRENT_CRONTAB=$(crontab -l 2>/dev/null || true)

CLEAN_CRONTAB=$(echo "$CURRENT_CRONTAB" | \
    grep -v "cron_assignment_marker" || true)

printf "%s\n" "$CLEAN_CRONTAB" | crontab -

# --------------------------------------------------
# Test 3: Execute student script
# --------------------------------------------------

echo
echo "Test 3: Running student script"

if bash "$SCRIPT" > /tmp/student_cron_setup_output.txt 2>&1; then
    echo "PASS: Student script executed successfully."
    passed=$((passed + 1))
else
    echo "FAIL: Student script failed."
    echo "----- Student output -----"
    cat /tmp/student_cron_setup_output.txt
    echo "--------------------------"
    failed=$((failed + 1))
fi

# --------------------------------------------------
# Read installed crontab
# --------------------------------------------------

echo
echo "Installed crontab:"
echo "--------------------------------------"

INSTALLED_CRONTAB=$(crontab -l 2>/dev/null || true)

echo "$INSTALLED_CRONTAB"

echo "--------------------------------------"

# --------------------------------------------------
# Test 4: Check crontab command was used
# --------------------------------------------------

echo
echo "Test 4: Checking use of crontab"

if grep -Eq "crontab" "$SCRIPT"; then
    echo "PASS: Student script uses crontab."
    passed=$((passed + 1))
else
    echo "FAIL: Student script does not appear to use crontab."
    failed=$((failed + 1))
fi

# --------------------------------------------------
# Test 5: Check every-minute schedule
# --------------------------------------------------

echo
echo "Test 5: Checking cron schedule"

if echo "$INSTALLED_CRONTAB" | \
    grep -Eq '^[[:space:]]*\*[[:space:]]+\*[[:space:]]+\*[[:space:]]+\*[[:space:]]+\*[[:space:]]+'; then

    echo "PASS: Cron job is scheduled every minute."
    passed=$((passed + 1))
else
    echo "FAIL: No every-minute cron schedule found."
    failed=$((failed + 1))
fi

# --------------------------------------------------
# Test 6: Check cron_job.sh appears in crontab
# --------------------------------------------------

echo
echo "Test 6: Checking scheduled script"

if echo "$INSTALLED_CRONTAB" | grep -q "starter/cron_job.sh"; then
    echo "PASS: cron_job.sh is scheduled."
    passed=$((passed + 1))
else
    echo "FAIL: cron_job.sh was not found in crontab."
    failed=$((failed + 1))
fi

# --------------------------------------------------
# Test 7: Check dynamic path
# --------------------------------------------------

echo
echo "Test 7: Checking path handling"

if grep -Eq '(\$\(pwd\)|\$PWD|realpath|readlink|dirname|SCRIPT_DIR)' "$SCRIPT"; then
    echo "PASS: Script appears to generate/use a dynamic path."
    passed=$((passed + 1))
else
    echo "FAIL: Script does not appear to generate a dynamic path."
    failed=$((failed + 1))
fi

# --------------------------------------------------
# Test 8: Check duplicate prevention
# --------------------------------------------------

echo
echo "Test 8: Checking duplicate prevention"

COUNT=$(echo "$INSTALLED_CRONTAB" | \
    grep -c "starter/cron_job.sh" || true)

if [[ "$COUNT" -eq 1 ]]; then
    echo "PASS: Exactly one assignment cron entry exists."
    passed=$((passed + 1))
else
    echo "FAIL: Expected exactly one assignment cron entry; found $COUNT."
    failed=$((failed + 1))
fi

# --------------------------------------------------
# Test 9: Check cron_job.sh contents
# --------------------------------------------------

echo
echo "Test 9: Checking cron job script"

if grep -q "date" "$CRON_JOB" && \
   grep -q "/tmp/cron_assignment_output.txt" "$CRON_JOB"; then

    echo "PASS: cron_job.sh contains the expected job."
    passed=$((passed + 1))
else
    echo "FAIL: cron_job.sh does not contain the expected job."
    failed=$((failed + 1))
fi

# --------------------------------------------------
# Cleanup
# --------------------------------------------------

echo
echo "Cleaning up test crontab..."

FINAL_CRONTAB=$(crontab -l 2>/dev/null || true)

echo "$FINAL_CRONTAB" | \
    grep -v "starter/cron_job.sh" | \
    crontab -

# --------------------------------------------------
# Final result
# --------------------------------------------------

echo
echo "======================================"
echo " AUTOGRADING RESULT"
echo "======================================"
echo "Passed: $passed"
echo "Failed: $failed"
echo "======================================"

if [[ "$failed" -eq 0 ]]; then
    echo "ALL TESTS PASSED"
    exit 0
else
    echo "SOME TESTS FAILED"
    exit 1
fi
