#!/bin/bash
#
# Sync Patches Helper Script
# Applies JER patches to bitcoin-core after pulling changes
#

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🔧 Syncing JER patches to bitcoin-core...${NC}"
echo ""

# Check if bitcoin-core exists
if [ ! -d "bitcoin-core" ]; then
    echo -e "${YELLOW}⚠️  bitcoin-core directory not found${NC}"
    echo "Run ./setup.sh first to clone Bitcoin Core"
    exit 1
fi

# Check if patches exist
if [ ! -f "patches/chainparams.cpp" ]; then
    echo -e "${YELLOW}⚠️  patches/chainparams.cpp not found${NC}"
    exit 1
fi

# Apply patches
echo "Copying patches/chainparams.cpp → bitcoin-core/src/kernel/chainparams.cpp"
cp patches/chainparams.cpp bitcoin-core/src/kernel/chainparams.cpp

echo -e "${GREEN}✓ Patches applied${NC}"
echo ""
echo "Next steps:"
echo "  1. Rebuild: ${GREEN}./scripts/build-jer.sh${NC}"
echo "  2. Test:    ${GREEN}./scripts/start-regtest.sh${NC}"
echo ""
