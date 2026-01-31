#!/bin/bash
#
# BigFive Updater - Quick Test with Base Images
# Uses pre-built base images with volume mount (no rebuild needed)
#
# Usage: ./quick-test.sh [distro|all] [--help|--dry-run|--json]
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
BLUE='\033[0;34m'
NC='\033[0m'

TOTAL=0
PASSED=0
FAILED=0

run_test() {
    local distro=$1
    local test_name=$2
    local test_cmd=$3
    local image="${DISTROS[$distro]}"

    ((++TOTAL))
    echo -e "${BLUE}[$distro]${NC} $test_name"

    # Alpine uses /bin/sh
    local shell="/bin/bash"
    [[ "$distro" == "alpine" ]] && shell="/bin/sh"

    if docker run --rm \
        -v "${PROJECT_DIR}:/app:ro" \
        -w /app \
        "$image" \
        "$shell" -c "$test_cmd" > /dev/null 2>&1; then
        echo -e "${GREEN}  ✓ PASS${NC}"
        ((++PASSED))
        return 0
    else
        echo -e "${RED}  ✗ FAIL${NC}"
        ((++FAILED))
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
  --dry-run   Test dry-run mode (default)
  --json      Test JSON output

Prerequisites:
  Run ./build-base-images.sh first to create base images

Examples:
  ./quick-test.sh all           # Test all distros
  ./quick-test.sh ubuntu        # Test only Ubuntu
  ./quick-test.sh all --json    # Test JSON output on all
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
    esac
done

# Check if base images exist
if ! docker images | grep -q "bigfive-base"; then
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
    esac
done

# Summary
echo ""
echo "=========================================="
echo "  SUMMARY: $PASSED/$TOTAL passed"
echo "=========================================="

[[ $FAILED -gt 0 ]] && exit 1
exit 0
