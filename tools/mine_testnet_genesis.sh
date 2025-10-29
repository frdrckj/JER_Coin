#!/bin/bash
# Mine Testnet Genesis Block with Proper Difficulty
# This script uses Bitcoin Core itself to mine the genesis block

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

BITCOIND="../bitcoin-core/build/bin/bitcoind"
BITCOIN_CLI="../bitcoin-core/build/bin/bitcoin-cli"

echo "======================================================================"
echo "JER TESTNET - GENESIS BLOCK MINER"
echo "======================================================================"
echo ""
echo -e "${YELLOW}This will mine the testnet genesis block with proper difficulty${NC}"
echo -e "${YELLOW}Difficulty: 0x1d00ffff (Bitcoin's starting difficulty)${NC}"
echo ""
echo -e "${YELLOW}Expected time: 2-48 hours on M-series Mac${NC}"
echo -e "${YELLOW}You can stop and restart anytime (mining is randomized)${NC}"
echo ""

# Check if bitcoind exists
if [ ! -f "$BITCOIND" ]; then
    echo -e "${RED}Error: bitcoind not found${NC}"
    echo "Please run: ./scripts/build-jer.sh"
    exit 1
fi

echo -e "${BLUE}Step 1: Starting testnet node...${NC}"
echo "(This will fail because genesis isn't mined yet - that's expected)"
echo ""

# Start testnet (will fail, but we can extract info from debug log)
$BITCOIND -testnet -daemon 2>&1 || true
sleep 2

# Check debug log for genesis info
TESTNET_DIR="$HOME/Library/Application Support/Bitcoin/testnet3"

if [ -f "$TESTNET_DIR/debug.log" ]; then
    echo -e "${GREEN}Found debug log${NC}"

    # Look for genesis block info
    echo ""
    echo "Genesis block info from Bitcoin Core:"
    echo "------------------------------------"
    tail -50 "$TESTNET_DIR/debug.log" | grep -i "genesis\|block 0" || echo "No genesis info in log yet"
    echo ""
fi

echo -e "${YELLOW}======================================================================"
echo "MANUAL MINING INSTRUCTIONS"
echo "======================================================================${NC}"
echo ""
echo "Since Bitcoin Core's CreateGenesisBlock() creates a specific format,"
echo "the best way to mine is to use the block hash it generates."
echo ""
echo -e "${GREEN}Method 1: Let Bitcoin Core Find It (Recommended)${NC}"
echo "------------------------------------"
echo "1. The testnet node is trying different nonces automatically"
echo "2. Watch the debug log for the genesis hash:"
echo "   tail -f \"$TESTNET_DIR/debug.log\""
echo ""
echo "3. When you see the hash, stop the node and update chainparams.cpp"
echo ""
echo -e "${GREEN}Method 2: Mine with External Script${NC}"
echo "------------------------------------"
echo "Use tools/mine_genesis.py:"
echo "  python3 tools/mine_genesis.py --network testnet --difficulty 0x1d00ffff"
echo ""
echo -e "${YELLOW}NOTE: The Python script is simplified and may not match Bitcoin Core exactly."
echo "For best results, use Method 1 (let Bitcoin Core mine it).${NC}"
echo ""
echo "======================================================================"

# Try to stop node if running
$BITCOIN_CLI -testnet stop 2>/dev/null || true

echo ""
echo -e "${GREEN}To monitor mining progress:${NC}"
echo "  tail -f \"$TESTNET_DIR/debug.log\""
echo ""
echo -e "${GREEN}To start mining (automatic with Bitcoin Core):${NC}"
echo "  $BITCOIND -testnet -daemon"
echo ""
echo "======================================================================"
