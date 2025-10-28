#!/bin/bash
# Jer Cryptocurrency - CMake Build Script
# Builds Bitcoin Core (Jer) using modern CMake build system

set -e  # Exit on error

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Configuration
BUILD_DIR="bitcoin-core"
BUILD_OUTPUT_DIR="bitcoin-core/build"
NUM_CORES=$(sysctl -n hw.ncpu 2>/dev/null || echo 4)

echo "======================================================================"
echo "JER CRYPTOCURRENCY - BUILD"
echo "======================================================================"
echo ""

# Check if we're in the right directory
if [ ! -d "$BUILD_DIR" ]; then
    echo -e "${RED}Error: $BUILD_DIR directory not found${NC}"
    echo "Please run this script from the jer-cryptocurrency directory"
    exit 1
fi

echo -e "${GREEN}Step 1: Checking dependencies...${NC}"
command -v cmake >/dev/null 2>&1 || { echo -e "${RED}cmake is required but not installed. Run: brew install cmake${NC}"; exit 1; }
echo -e "${GREEN}✓ Dependencies check passed${NC}"
echo ""

echo -e "${GREEN}Step 2: Creating build directory...${NC}"
cd "$BUILD_DIR"
rm -rf build
mkdir -p build
cd build
echo -e "${GREEN}✓ Build directory created${NC}"
echo ""

echo -e "${GREEN}Step 3: Configuring with CMake...${NC}"
echo "Configuration options:"
echo "  - Build type: Release"
echo "  - GUI: Disabled (daemon/CLI only)"
echo "  - Tests: Disabled (for faster build)"
echo "  - Wallet: Enabled"
echo ""

cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_GUI=OFF \
    -DBUILD_TESTS=OFF \
    -DBUILD_BENCH=OFF \
    -DENABLE_WALLET=ON \
    -DWITH_BDB=ON \
    -DENABLE_IPC=OFF \
    -DBUILD_TX=ON \
    -DBUILD_WALLET_TOOL=ON

if [ $? -ne 0 ]; then
    echo -e "${RED}Error: CMake configuration failed${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Configuration complete${NC}"
echo ""

echo -e "${GREEN}Step 4: Building (using $NUM_CORES cores)...${NC}"
echo "This will take 10-30 minutes depending on your system..."
echo ""

START_TIME=$(date +%s)
cmake --build . -j$NUM_CORES

if [ $? -ne 0 ]; then
    echo -e "${RED}Error: build failed${NC}"
    exit 1
fi

END_TIME=$(date +%s)
BUILD_TIME=$((END_TIME - START_TIME))
echo ""
echo -e "${GREEN}✓ Build complete in $BUILD_TIME seconds${NC}"
echo ""

echo "======================================================================"
echo -e "${GREEN}BUILD SUCCESSFUL!${NC}"
echo "======================================================================"
echo ""
echo "Built binaries:"
echo "  Daemon:  $(pwd)/bin/bitcoind"
echo "  CLI:     $(pwd)/bin/bitcoin-cli"
echo "  TX tool: $(pwd)/bin/bitcoin-tx"
echo "  Wallet:  $(pwd)/bin/bitcoin-wallet"
echo ""
echo "Next steps:"
echo "  1. Test on regtest:"
echo "     cd bitcoin-core/build"
echo "     ./bin/bitcoind -regtest -daemon"
echo "     ./bin/bitcoin-cli -regtest getblockchaininfo"
echo ""
echo "  2. Verify genesis block:"
echo "     ./bin/bitcoin-cli -regtest getblockhash 0"
echo "     (Should be: 23ed3a57f87b65a0b4a50e820eefa73b16530dbca359e0803d55843a8238d96e)"
echo ""
echo "  3. Test mining:"
echo "     ./bin/bitcoin-cli -regtest createwallet \"test\""
echo "     ADDR=\$(./bin/bitcoin-cli -regtest getnewaddress)"
echo "     ./bin/bitcoin-cli -regtest generatetoaddress 101 \$ADDR"
echo "     ./bin/bitcoin-cli -regtest getbalance"
echo ""
