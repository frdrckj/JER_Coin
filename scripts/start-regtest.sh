#!/bin/bash
# Start Jer Cryptocurrency in regtest mode

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

BITCOIND="../bitcoin-core/build/bin/bitcoind"
BITCOIN_CLI="../bitcoin-core/build/bin/bitcoin-cli"

if [ ! -f "$BITCOIND" ]; then
    echo "Error: bitcoind not found. Please run ./scripts/build-jer.sh first"
    exit 1
fi

echo "======================================================================"
echo "STARTING JER CRYPTOCURRENCY - REGTEST MODE"
echo "======================================================================"
echo ""

# Clean old data
echo -e "${YELLOW}Cleaning old regtest data...${NC}"
rm -rf "$HOME/Library/Application Support/Bitcoin/regtest"
echo -e "${GREEN}✓ Clean slate ready${NC}"
echo ""

# Start daemon
echo -e "${GREEN}Starting bitcoind in regtest mode...${NC}"
$BITCOIND -regtest -daemon

# Wait for startup
echo "Waiting for node to start..."
sleep 3

# Check if running
if $BITCOIN_CLI -regtest getblockchaininfo &>/dev/null; then
    echo -e "${GREEN}✓ Node started successfully!${NC}"
    echo ""
    echo "Blockchain info:"
    $BITCOIN_CLI -regtest getblockchaininfo | grep -E "chain|blocks|bestblockhash"
    echo ""
    echo "Genesis block hash:"
    $BITCOIN_CLI -regtest getblockhash 0
    echo ""
    echo "======================================================================"
    echo "Node is running! Use these commands:"
    echo "  Stop:    $BITCOIN_CLI -regtest stop"
    echo "  Info:    $BITCOIN_CLI -regtest getblockchaininfo"
    echo "  Balance: $BITCOIN_CLI -regtest getbalance"
    echo "======================================================================"
else
    echo "Error: Node failed to start. Check debug.log"
    exit 1
fi
