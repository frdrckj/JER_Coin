#!/bin/bash
# Start Jer Cryptocurrency Testnet Node

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

BITCOIND="$PROJECT_ROOT/bitcoin-core/build/bin/bitcoind"

echo "======================================================================"
echo "STARTING JER CRYPTOCURRENCY - TESTNET MODE"
echo "======================================================================"
echo ""

if [ ! -f "$BITCOIND" ]; then
    echo -e "${RED}Error: bitcoind not found${NC}"
    echo "Build it first with: ./scripts/build-jer.sh"
    exit 1
fi

# Check if already running
if pgrep -f "bitcoind.*testnet" > /dev/null; then
    echo -e "${YELLOW}Testnet node is already running${NC}"
    exit 0
fi

echo -e "${GREEN}Starting bitcoind in testnet mode...${NC}"

# Start testnet node
$BITCOIND -testnet -daemon \
    -listen=1 \
    -discover=1 \
    -port=18732 \
    -rpcport=18733 \
    -rpcbind=0.0.0.0 \
    -rpcallowip=0.0.0.0/0 \
    -fallbackfee=0.00001

# Wait for node to start
echo "Waiting for node to start..."
sleep 3

# Check if node started successfully
if $PROJECT_ROOT/bitcoin-core/build/bin/bitcoin-cli -testnet getblockchaininfo &>/dev/null; then
    echo -e "${GREEN}✓ Node started successfully!${NC}"
    echo ""

    # Show node info
    $PROJECT_ROOT/bitcoin-core/build/bin/bitcoin-cli -testnet getblockchaininfo

    echo ""
    echo "======================================================================"
    echo "Testnet node is running!"
    echo ""
    echo "Commands:"
    echo "  Info:    bitcoin-core/build/bin/bitcoin-cli -testnet getblockchaininfo"
    echo "  Peers:   bitcoin-core/build/bin/bitcoin-cli -testnet getpeerinfo"
    echo "  Stop:    bitcoin-core/build/bin/bitcoin-cli -testnet stop"
    echo ""
    echo "Ports:"
    echo "  P2P:  18732 (for other nodes to connect)"
    echo "  RPC:  18733 (for local wallet commands)"
    echo "======================================================================"
else
    echo -e "${RED}Error: Node failed to start. Check debug.log${NC}"
    echo "Debug log: ~/.bitcoin/testnet3/debug.log"
    exit 1
fi
