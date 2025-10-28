#!/bin/bash
# Jer Cryptocurrency Wallet Access Guide

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

BITCOIN_CLI="$PROJECT_ROOT/bitcoin-core/build/bin/bitcoin-cli"
NETWORK="${1:-regtest}"

echo "======================================================================"
echo "JER CRYPTOCURRENCY - WALLET GUIDE"
echo "======================================================================"
echo ""

if [ ! -f "$BITCOIN_CLI" ]; then
    echo "Error: bitcoin-cli not found"
    exit 1
fi

CLI_CMD="$BITCOIN_CLI"
if [ "$NETWORK" = "regtest" ]; then
    CLI_CMD="$BITCOIN_CLI -regtest"
elif [ "$NETWORK" = "testnet" ]; then
    CLI_CMD="$BITCOIN_CLI -testnet"
fi

# Check if node is running
if ! $CLI_CMD getblockchaininfo &>/dev/null 2>&1; then
    echo "Error: Node is not running for $NETWORK"
    echo "Start it first with: ./scripts/start-regtest.sh"
    exit 1
fi

echo -e "${GREEN}WALLET COMMANDS${NC}"
echo ""
echo -e "${BLUE}1. Create a new wallet:${NC}"
echo "   $CLI_CMD createwallet \"mywallet\""
echo ""
echo -e "${BLUE}2. List all wallets:${NC}"
echo "   $CLI_CMD listwallets"
echo ""
echo -e "${BLUE}3. Load an existing wallet:${NC}"
echo "   $CLI_CMD loadwallet \"mywallet\""
echo ""
echo -e "${BLUE}4. Get wallet balance:${NC}"
echo "   $CLI_CMD getbalance"
echo ""
echo -e "${BLUE}5. Get a new receiving address:${NC}"
echo "   $CLI_CMD getnewaddress"
echo ""
echo -e "${BLUE}6. List all addresses:${NC}"
echo "   $CLI_CMD listreceivedbyaddress 0 true"
echo ""
echo -e "${BLUE}7. Get wallet info:${NC}"
echo "   $CLI_CMD getwalletinfo"
echo ""
echo -e "${BLUE}8. Send JER to an address:${NC}"
echo "   $CLI_CMD sendtoaddress <address> <amount>"
echo ""
echo -e "${BLUE}9. List transactions:${NC}"
echo "   $CLI_CMD listtransactions"
echo ""
echo -e "${BLUE}10. Backup wallet:${NC}"
echo "   $CLI_CMD backupwallet \"/path/to/backup.dat\""
echo ""
echo -e "${BLUE}11. Unload wallet:${NC}"
echo "   $CLI_CMD unloadwallet \"mywallet\""
echo ""

echo "======================================================================"
echo -e "${YELLOW}CURRENT WALLET STATUS${NC}"
echo "======================================================================"
echo ""

WALLETS=$($CLI_CMD listwallets 2>/dev/null || echo "[]")
if [ "$WALLETS" = "[]" ]; then
    echo "No wallets loaded."
    echo ""
    echo "Create your first wallet with:"
    echo "  $CLI_CMD createwallet \"mywallet\""
else
    echo "Loaded wallets:"
    echo "$WALLETS"
    echo ""
    echo "Balance: $($CLI_CMD getbalance 2>/dev/null || echo 'N/A') JER"
    echo ""
fi

echo ""
echo "======================================================================"
echo -e "${YELLOW}WALLET DATA LOCATION${NC}"
echo "======================================================================"
if [ "$NETWORK" = "regtest" ]; then
    echo "~/Library/Application Support/Bitcoin/regtest/wallets/"
elif [ "$NETWORK" = "testnet" ]; then
    echo "~/Library/Application Support/Bitcoin/testnet3/wallets/"
else
    echo "~/Library/Application Support/Bitcoin/wallets/"
fi
echo ""
