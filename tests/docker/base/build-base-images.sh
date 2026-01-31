#!/bin/bash
#
# BigFive Updater - Base Image Builder
# Builds pre-configured images for faster testing
#
# Usage: ./build-base-images.sh [distro|all]
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

declare -A DISTROS=(
    [ubuntu]="Dockerfile.ubuntu"
    [fedora]="Dockerfile.fedora"
    [arch]="Dockerfile.arch"
    [opensuse]="Dockerfile.opensuse"
    [alpine]="Dockerfile.alpine"
)

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

build_image() {
    local distro=$1
    local dockerfile="${DISTROS[$distro]}"
    local image_name="bigfive-base-${distro}"

    echo -e "${BLUE}Building ${image_name}...${NC}"

    docker build \
        -f "$SCRIPT_DIR/$dockerfile" \
        -t "$image_name" \
        "$SCRIPT_DIR" 2>&1 | tail -3

    echo -e "${GREEN}✓ ${image_name} built${NC}"
    echo ""
}

TARGET="${1:-all}"

if [[ "$TARGET" == "all" ]]; then
    echo "Building all base images..."
    echo ""
    for distro in "${!DISTROS[@]}"; do
        build_image "$distro"
    done
else
    if [[ -z "${DISTROS[$TARGET]:-}" ]]; then
        echo "Unknown distro: $TARGET"
        echo "Available: ${!DISTROS[*]} all"
        exit 1
    fi
    build_image "$TARGET"
fi

echo "=== Base Images ==="
docker images | grep bigfive-base || true
