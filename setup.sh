#!/bin/bash
#
# JER Cryptocurrency Setup Script
# This script clones Bitcoin Core and applies JER patches
#

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
BITCOIN_REPO="https://github.com/bitcoin/bitcoin.git"
BITCOIN_BRANCH="master"  # or specify a tag like "v26.0"
BITCOIN_DIR="bitcoin-core"

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   JER Cryptocurrency Setup Script     ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# Check if bitcoin-core already exists
if [ -d "$BITCOIN_DIR" ]; then
    echo -e "${YELLOW}⚠️  Bitcoin Core directory already exists${NC}"
    echo ""
    read -p "Do you want to re-clone Bitcoin Core? (y/N): " -n 1 -r
    echo ""

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Removing existing Bitcoin Core...${NC}"
        rm -rf "$BITCOIN_DIR"
    else
        echo -e "${GREEN}Skipping Bitcoin Core clone${NC}"
        SKIP_CLONE=true
    fi
fi

# Clone Bitcoin Core
if [ "$SKIP_CLONE" != "true" ]; then
    echo -e "${BLUE}📥 Cloning Bitcoin Core...${NC}"
    git clone --depth 1 --branch "$BITCOIN_BRANCH" "$BITCOIN_REPO" "$BITCOIN_DIR"
    echo -e "${GREEN}✓ Bitcoin Core cloned${NC}"
    echo ""
fi

# Apply JER patches
echo -e "${BLUE}🔧 Applying JER patches...${NC}"

if [ ! -f "patches/chainparams.cpp" ]; then
    echo -e "${RED}✗ Error: patches/chainparams.cpp not found${NC}"
    exit 1
fi

echo "  → Copying modified chainparams.cpp..."
cp patches/chainparams.cpp "$BITCOIN_DIR/src/kernel/chainparams.cpp"

echo -e "${GREEN}✓ JER patches applied${NC}"
echo ""

# Check for dependencies
echo -e "${BLUE}🔍 Checking dependencies...${NC}"

check_command() {
    if command -v $1 &> /dev/null; then
        echo -e "${GREEN}  ✓ $1${NC}"
        return 0
    else
        echo -e "${RED}  ✗ $1 (not found)${NC}"
        return 1
    fi
}

MISSING_DEPS=0

check_command "cmake" || MISSING_DEPS=1
check_command "make" || MISSING_DEPS=1
check_command "g++" || MISSING_DEPS=1 || check_command "clang++" || MISSING_DEPS=1

echo ""

if [ $MISSING_DEPS -eq 1 ]; then
    echo -e "${YELLOW}⚠️  Some dependencies are missing${NC}"
    echo ""
    echo "Install missing dependencies:"
    echo ""

    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "  macOS (Homebrew):"
        echo "  $ brew install cmake pkg-config boost libevent sqlite berkeley-db@4"
        echo ""
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "  Ubuntu/Debian:"
        echo "  $ sudo apt-get install build-essential cmake pkg-config"
        echo "  $ sudo apt-get install libboost-all-dev libevent-dev libssl-dev"
        echo "  $ sudo apt-get install libdb++-dev libsqlite3-dev"
        echo ""
        echo "  Fedora:"
        echo "  $ sudo dnf install cmake boost-devel libevent-devel openssl-devel"
        echo "  $ sudo dnf install libdb-cxx-devel sqlite-devel"
        echo ""
    fi

    echo "Then run ./setup.sh again"
    echo ""
else
    echo -e "${GREEN}✓ All basic dependencies found${NC}"
    echo ""
fi

# Summary
echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║            Setup Complete!             ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""
echo "Next steps:"
echo ""
echo "  1. Build JER cryptocurrency:"
echo -e "     ${GREEN}./scripts/build-jer.sh${NC}"
echo ""
echo "  2. Test on regtest:"
echo -e "     ${GREEN}./scripts/start-regtest.sh${NC}"
echo -e "     ${GREEN}./scripts/test-mining.sh${NC}"
echo ""
echo "  3. Read the documentation:"
echo -e "     ${GREEN}cat CONFIGURATION-COMPLETE.md${NC}"
echo ""

if [ $MISSING_DEPS -eq 1 ]; then
    echo -e "${YELLOW}⚠️  Don't forget to install missing dependencies first!${NC}"
    echo ""
    exit 1
fi

echo -e "${GREEN}Happy building! 🚀${NC}"
echo ""
