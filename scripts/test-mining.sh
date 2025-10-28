#!/bin/bash
# Test mining on Jer Cryptocurrency regtest network

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

BITCOIN_CLI="$PROJECT_ROOT/bitcoin-core/build/bin/bitcoin-cli"

if [ ! -f "$BITCOIN_CLI" ]; then
    echo "Error: bitcoin-cli not found. Please build first."
    exit 1
fi

echo "======================================================================"
echo "JER CRYPTOCURRENCY - MINING TEST"
echo "======================================================================"
echo ""

# Check if node is running
if ! $BITCOIN_CLI -regtest getblockchaininfo &>/dev/null; then
    echo "Error: Node is not running. Start it first with ./scripts/start-regtest.sh"
    exit 1
fi

echo -e "${GREEN}Step 1: Creating wallet...${NC}"
$BITCOIN_CLI -regtest createwallet "test" 2>/dev/null || echo "Wallet already exists, continuing..."
echo -e "${GREEN}✓ Wallet ready${NC}"
echo ""

echo -e "${GREEN}Step 2: Generating address...${NC}"
ADDR=$($BITCOIN_CLI -regtest getnewaddress)
echo "Mining to address: $ADDR"
echo ""

echo -e "${GREEN}Step 3: Mining 101 blocks...${NC}"
echo "(This allows the first block reward to mature)"
$BITCOIN_CLI -regtest generatetoaddress 101 $ADDR > /dev/null
echo -e "${GREEN}✓ Mining complete!${NC}"
echo ""

echo -e "${GREEN}Step 4: Checking results...${NC}"
BALANCE=$($BITCOIN_CLI -regtest getbalance)
BLOCKS=$($BITCOIN_CLI -regtest getblockcount)

echo ""
echo "======================================================================"
echo "MINING TEST RESULTS"
echo "======================================================================"
echo "Blocks mined: $BLOCKS"
echo "Wallet balance: $BALANCE JER"
echo ""

if [ $(echo "$BALANCE > 0" | bc) -eq 1 ]; then
    echo -e "${GREEN}✓ SUCCESS! Mining works correctly${NC}"
else
    echo "Warning: Balance is 0, this might indicate an issue"
fi
echo ""
