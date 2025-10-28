#!/bin/bash
# Stop Jer Cryptocurrency node

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

BITCOIN_CLI="../bitcoin-core/build/bin/bitcoin-cli"

if [ ! -f "$BITCOIN_CLI" ]; then
    echo "Error: bitcoin-cli not found"
    exit 1
fi

# Default to regtest if no argument provided
NETWORK="${1:-regtest}"

echo "Stopping Jer node ($NETWORK)..."

if [ "$NETWORK" = "regtest" ]; then
    $BITCOIN_CLI -regtest stop
elif [ "$NETWORK" = "testnet" ]; then
    $BITCOIN_CLI -testnet stop
elif [ "$NETWORK" = "mainnet" ]; then
    $BITCOIN_CLI stop
else
    echo "Usage: $0 [regtest|testnet|mainnet]"
    exit 1
fi

echo -e "${GREEN}✓ Shutdown signal sent${NC}"
