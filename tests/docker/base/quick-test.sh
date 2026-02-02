#!/bin/bash
#
# BigFive Updater - Quick Test with Base Images
# Uses pre-built base images with volume mount (no rebuild needed)
#
# Usage: ./quick-test.sh [distro|all] [--help|--dry-run|--json|--doctor|--history|--full]
#
# v6.1.0: Added --doctor and --history tests
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../../.." && pwd)"

declare -A DISTROS=(
    [ubuntu]="bigfive-base-ubuntu"
    [fedora]="bigfive-base-fedora"
    [arch]="bigfive-base-arch"
    [opensuse]="bigfive-base-opensuse"
    [alpine]="bigfive-base-alpine"
)

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

TOTAL=0
PASSED=0
FAILED=0

declare -A RESULTS

run_test() {
    local distro=$1
    local test_name=$2
    local test_cmd=$3
    local image="${DISTROS[$distro]}"

    ((++TOTAL)) || true
    printf "${BLUE}[%-8s]${NC} %-12s " "$distro" "$test_name"

    # Alpine uses /bin/sh
    local shell="/bin/bash"
    [[ "$distro" == "alpine" ]] && shell="/bin/sh"

    if docker run --rm \
        --user root \
        -v "${PROJECT_DIR}:/app:ro" \
        -w /app \
        "$image" \
        "$shell" -c "$test_cmd" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ PASS${NC}"
        ((++PASSED)) || true
        RESULTS["${distro}_${test_name}"]="PASS"
        return 0
    else
        echo -e "${RED}✗ FAIL${NC}"
        ((++FAILED)) || true
        RESULTS["${distro}_${test_name}"]="FAIL"
        return 1
    fi
}

show_help() {
    cat << 'EOF'
BigFive Quick Test - Uses pre-built base images

Usage: ./quick-test.sh [distro|all] [options]

Distros: ubuntu, fedora, arch, opensuse, alpine, all

Options:
  --help      Show this help
  --dry-run   Test dry-run mode
  --json      Test JSON output
  --doctor    Test --doctor command (v6.1.0+)
  --history   Test --history command (v6.1.0+)
  --full      Run all tests (help, dry-run, json, doctor, history)

Prerequisites:
  Run ./build-base-images.sh first to create base images

Examples:
  ./quick-test.sh all           # Test --help on all distros
  ./quick-test.sh ubuntu        # Test only Ubuntu
  ./quick-test.sh all --json    # Test JSON output on all
  ./quick-test.sh all --doctor  # Test --doctor on all (v6.1.0)
  ./quick-test.sh all --full    # Run all tests on all distros
EOF
}

# Parse args
TARGET="${1:-all}"
TEST_MODE="help"

for arg in "$@"; do
    case $arg in
        --help|-h) show_help; exit 0 ;;
        --dry-run) TEST_MODE="dry-run" ;;
        --json) TEST_MODE="json" ;;
        --doctor) TEST_MODE="doctor" ;;
        --history) TEST_MODE="history" ;;
        --full) TEST_MODE="full" ;;
    esac
done

# Check if base images exist
if ! docker images --format "{{.Repository}}" 2>/dev/null | grep -q "bigfive-base"; then
    echo -e "${RED}Base images not found!${NC}"
    echo "Run: ./build-base-images.sh all"
    exit 1
fi

echo "=========================================="
echo "  BigFive Quick Test Suite"
echo "  Mode: $TEST_MODE"
echo "=========================================="
echo ""

# Determine which distros to test
if [[ "$TARGET" == "all" ]]; then
    TARGETS=("ubuntu" "fedora" "arch" "opensuse" "alpine")
else
    TARGETS=("$TARGET")
fi

# Run tests
for distro in "${TARGETS[@]}"; do
    case $TEST_MODE in
        help)
            run_test "$distro" "help" "./guncel --help" || true
            ;;
        dry-run)
            run_test "$distro" "dry-run" "./guncel --dry-run" || true
            ;;
        json)
            run_test "$distro" "json" "./guncel --json --dry-run | head -5" || true
            ;;
        doctor)
            run_test "$distro" "doctor" "./guncel --doctor" || true
            ;;
        history)
            run_test "$distro" "history" "./guncel --history" || true
            ;;
        full)
            run_test "$distro" "help" "./guncel --help" || true
            run_test "$distro" "dry-run" "./guncel --dry-run" || true
            run_test "$distro" "json" "./guncel --json --dry-run | head -5" || true
            run_test "$distro" "doctor" "./guncel --doctor" || true
            run_test "$distro" "history" "./guncel --history" || true
            ;;
    esac
done

# Summary
echo ""
echo "=========================================="
echo "  SUMMARY: $PASSED/$TOTAL passed"
if [[ $FAILED -gt 0 ]]; then
    echo -e "  ${RED}$FAILED test(s) failed${NC}"
fi
echo "=========================================="

# Print table for --full mode
if [[ "$TEST_MODE" == "full" ]]; then
    echo ""
    echo "┌──────────┬────────┬─────────┬────────┬─────────┬──────────┐"
    echo "│ Distro   │  help  │ dry-run │  json  │ doctor  │ history  │"
    echo "├──────────┼────────┼─────────┼────────┼─────────┼──────────┤"
    for distro in "${TARGETS[@]}"; do
        h="${RESULTS[${distro}_help]:-N/A}"
        d="${RESULTS[${distro}_dry-run]:-N/A}"
        j="${RESULTS[${distro}_json]:-N/A}"
        doc="${RESULTS[${distro}_doctor]:-N/A}"
        his="${RESULTS[${distro}_history]:-N/A}"
        # Color coding
        [[ "$h" == "PASS" ]] && h="${GREEN}PASS${NC}" || h="${RED}FAIL${NC}"
        [[ "$d" == "PASS" ]] && d="${GREEN}PASS${NC}" || d="${RED}FAIL${NC}"
        [[ "$j" == "PASS" ]] && j="${GREEN}PASS${NC}" || j="${RED}FAIL${NC}"
        [[ "$doc" == "PASS" ]] && doc="${GREEN}PASS${NC}" || doc="${RED}FAIL${NC}"
        [[ "$his" == "PASS" ]] && his="${GREEN}PASS${NC}" || his="${RED}FAIL${NC}"
        printf "│ %-8s │  %b  │   %b   │  %b  │   %b   │   %b    │\n" "$distro" "$h" "$d" "$j" "$doc" "$his"
    done
    echo "└──────────┴────────┴─────────┴────────┴─────────┴──────────┘"
fi

[[ $FAILED -gt 0 ]] && exit 1
exit 0
