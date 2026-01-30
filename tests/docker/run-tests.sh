#!/usr/bin/env bash
#
# BigFive Updater - Docker Multi-Distro Test Runner
# Usage: ./run-tests.sh [distro|all] [--dry-run|--update|--help]
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Distro definitions
declare -A DISTROS=(
    [ubuntu]="Dockerfile.ubuntu"
    [fedora]="Dockerfile.fedora"
    [arch]="Dockerfile.arch"
    [opensuse]="Dockerfile.opensuse"
    [alpine]="Dockerfile.alpine"
)

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo -e "\n${BLUE}=== $1 ===${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}! $1${NC}"
}

show_help() {
    cat << EOF
BigFive Updater - Docker Test Runner

Usage: $0 [distro|all] [options]

Distros:
  ubuntu    Ubuntu 24.04 (APT)
  fedora    Fedora 40 (DNF)
  arch      Arch Linux (Pacman)
  opensuse  openSUSE Tumbleweed (Zypper)
  alpine    Alpine 3.20 (APK)
  all       Test all distros

Options:
  --dry-run   Run guncel --dry-run (default)
  --update    Run actual updates (requires confirmation)
  --build     Only build images, don't run tests
  --help      Show this help

Examples:
  $0 ubuntu              # Test on Ubuntu with dry-run
  $0 all                 # Test all distros with dry-run
  $0 fedora --update     # Run real updates on Fedora
  $0 all --build         # Build all images only
EOF
}

build_image() {
    local distro=$1
    local dockerfile="${DISTROS[$distro]}"
    local image_name="bigfive-test-${distro}"

    print_header "Building $distro image"

    # Build from repo root with Dockerfile in tests/docker/
    docker build \
        -f "$SCRIPT_DIR/$dockerfile" \
        -t "$image_name" \
        "$REPO_ROOT" 2>&1 | tail -5

    print_success "$distro image built"
}

run_test() {
    local distro=$1
    local mode=$2
    local image_name="bigfive-test-${distro}"

    print_header "Testing $distro ($mode)"

    local cmd="./guncel --auto"
    [[ "$mode" == "dry-run" ]] && cmd="./guncel --dry-run"

    # Run with SELF_UPDATE_DISABLED to prevent overwriting local changes
    docker run --rm \
        -e SELF_UPDATE_DISABLED=true \
        "$image_name" \
        bash -c "chmod +x guncel && $cmd" 2>&1 | tail -20

    local exit_code=${PIPESTATUS[0]}
    if [[ $exit_code -eq 0 ]]; then
        print_success "$distro test passed"
    else
        print_error "$distro test failed (exit: $exit_code)"
        return 1
    fi
}

# Parse arguments
DISTRO="${1:-all}"
MODE="dry-run"
BUILD_ONLY=false

for arg in "$@"; do
    case $arg in
        --dry-run) MODE="dry-run" ;;
        --update) MODE="update" ;;
        --build) BUILD_ONLY=true ;;
        --help|-h) show_help; exit 0 ;;
    esac
done

# Validate distro
if [[ "$DISTRO" != "all" ]] && [[ -z "${DISTROS[$DISTRO]:-}" ]]; then
    print_error "Unknown distro: $DISTRO"
    echo "Available: ${!DISTROS[*]} all"
    exit 1
fi

# Confirmation for real updates
if [[ "$MODE" == "update" ]]; then
    print_warning "This will run REAL updates in containers."
    read -p "Continue? [y/N] " -n 1 -r
    echo
    [[ ! $REPLY =~ ^[Yy]$ ]] && exit 0
fi

# Run tests
FAILED=0
if [[ "$DISTRO" == "all" ]]; then
    for d in "${!DISTROS[@]}"; do
        build_image "$d" || ((FAILED++))
        if [[ "$BUILD_ONLY" == false ]]; then
            run_test "$d" "$MODE" || ((FAILED++))
        fi
    done
else
    build_image "$DISTRO" || ((FAILED++))
    if [[ "$BUILD_ONLY" == false ]]; then
        run_test "$DISTRO" "$MODE" || ((FAILED++))
    fi
fi

# Summary
echo ""
if [[ $FAILED -eq 0 ]]; then
    print_success "All tests passed!"
else
    print_error "$FAILED test(s) failed"
    exit 1
fi
