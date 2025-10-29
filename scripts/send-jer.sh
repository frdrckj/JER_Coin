#!/bin/bash
# Jer Cryptocurrency - Send JER Script

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

BITCOIN_CLI="$PROJECT_ROOT/bitcoin-core/build/bin/bitcoin-cli"
NETWORK="${NETWORK:-regtest}"

echo "======================================================================"
echo "JER CRYPTOCURRENCY - SEND JER"
echo "======================================================================"
echo ""

if [ ! -f "$BITCOIN_CLI" ]; then
    echo -e "${RED}Error: bitcoin-cli not found${NC}"
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
    echo -e "${RED}Error: Node is not running for $NETWORK${NC}"
    echo "Start it first with: ./scripts/start-regtest.sh"
    exit 1
fi

# Get list of wallets
WALLETS=$($CLI_CMD listwallets 2>/dev/null || echo "[]")
if [ "$WALLETS" = "[]" ]; then
    echo -e "${RED}Error: No wallets loaded${NC}"
    echo "Create a wallet first with:"
    echo "  $CLI_CMD createwallet \"mywallet\""
    exit 1
fi

# Parse wallet names
WALLET_NAMES=$(echo "$WALLETS" | grep -o '"[^"]*"' | tr -d '"')
WALLET_ARRAY=()
while IFS= read -r wallet; do
    if [ -n "$wallet" ]; then
        WALLET_ARRAY+=("$wallet")
    fi
done <<< "$WALLET_NAMES"

# Show available wallets with balances
echo -e "${YELLOW}Available wallets:${NC}"
echo ""
INDEX=1
for wallet in "${WALLET_ARRAY[@]}"; do
    BALANCE=$($CLI_CMD -rpcwallet="$wallet" getbalance 2>/dev/null || echo '0')
    echo "  $INDEX) $wallet - Balance: $BALANCE JER"
    ((INDEX++))
done
echo ""

# Select source wallet
if [ $# -ge 1 ]; then
    FROM_WALLET="$1"
else
    read -p "Select source wallet (number or name): " WALLET_INPUT
    if [[ "$WALLET_INPUT" =~ ^[0-9]+$ ]]; then
        WALLET_INDEX=$((WALLET_INPUT - 1))
        if [ $WALLET_INDEX -lt 0 ] || [ $WALLET_INDEX -ge ${#WALLET_ARRAY[@]} ]; then
            echo -e "${RED}Error: Invalid wallet selection${NC}"
            exit 1
        fi
        FROM_WALLET="${WALLET_ARRAY[$WALLET_INDEX]}"
    else
        FROM_WALLET="$WALLET_INPUT"
    fi
fi

# Verify source wallet exists
if ! echo "$WALLET_NAMES" | grep -q "^${FROM_WALLET}$"; then
    echo -e "${RED}Error: Wallet '$FROM_WALLET' not found${NC}"
    exit 1
fi

# Get source wallet balance
FROM_BALANCE=$($CLI_CMD -rpcwallet="$FROM_WALLET" getbalance 2>/dev/null)
echo ""
echo -e "${GREEN}Sending from:${NC} $FROM_WALLET"
echo -e "${GREEN}Available balance:${NC} $FROM_BALANCE JER"
echo ""

# Get destination wallet or address
if [ $# -ge 2 ]; then
    DESTINATION="$2"
else
    read -p "Enter destination wallet name OR address: " DESTINATION
fi

# Check if destination is a wallet name
if echo "$WALLET_NAMES" | grep -q "^${DESTINATION}$"; then
    echo -e "${BLUE}Destination is a wallet, generating new address...${NC}"
    TO_ADDRESS=$($CLI_CMD -rpcwallet="$DESTINATION" getnewaddress 2>/dev/null)
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error: Failed to get address from wallet '$DESTINATION'${NC}"
        exit 1
    fi
    echo -e "${GREEN}Destination address:${NC} $TO_ADDRESS"
else
    TO_ADDRESS="$DESTINATION"
    echo -e "${GREEN}Destination address:${NC} $TO_ADDRESS"
fi
echo ""

# Get amount
if [ $# -ge 3 ]; then
    AMOUNT="$3"
else
    read -p "Enter amount to send (JER): " AMOUNT
fi

# Validate amount
if ! [[ "$AMOUNT" =~ ^[0-9]+\.?[0-9]*$ ]]; then
    echo -e "${RED}Error: Invalid amount${NC}"
    exit 1
fi

# Check if amount is available
if (( $(echo "$AMOUNT > $FROM_BALANCE" | bc -l) )); then
    echo -e "${RED}Error: Insufficient balance${NC}"
    echo "Requested: $AMOUNT JER"
    echo "Available: $FROM_BALANCE JER"
    exit 1
fi

echo ""
echo -e "${YELLOW}Transaction Summary:${NC}"
echo "  From:   $FROM_WALLET"
echo "  To:     $TO_ADDRESS"
echo "  Amount: $AMOUNT JER"
echo ""

# Confirm transaction
if [ "$4" != "--yes" ]; then
    read -p "Confirm transaction? (y/n): " CONFIRM
    if [ "$CONFIRM" != "y" ] && [ "$CONFIRM" != "Y" ]; then
        echo "Transaction cancelled."
        exit 0
    fi
fi

# Send transaction
echo ""
echo -e "${BLUE}Sending transaction...${NC}"
TXID=$($CLI_CMD -rpcwallet="$FROM_WALLET" -named sendtoaddress address="$TO_ADDRESS" amount="$AMOUNT" fee_rate=1 2>&1)

if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Transaction failed${NC}"
    echo "$TXID"
    exit 1
fi

echo -e "${GREEN}✓ Transaction sent!${NC}"
echo "  TXID: $TXID"
echo ""

# Ask if user wants to mine a block
if [ "$5" != "--no-mine" ]; then
    read -p "Mine a block to confirm transaction? (y/n): " MINE
    if [ "$MINE" = "y" ] || [ "$MINE" = "Y" ]; then
        echo ""
        echo -e "${BLUE}Mining block...${NC}"

        # Get an address to mine to (from source wallet)
        MINE_ADDR=$($CLI_CMD -rpcwallet="$FROM_WALLET" getnewaddress 2>/dev/null)
        BLOCK_HASH=$($CLI_CMD generatetoaddress 1 "$MINE_ADDR" 2>&1 | grep -o '"[^"]*"' | tr -d '"' | head -1)

        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ Block mined!${NC}"
            echo "  Block hash: $BLOCK_HASH"
            echo ""

            # Show updated balances
            echo -e "${YELLOW}Updated balances:${NC}"
            NEW_FROM_BALANCE=$($CLI_CMD -rpcwallet="$FROM_WALLET" getbalance 2>/dev/null)
            echo "  $FROM_WALLET: $NEW_FROM_BALANCE JER"

            if echo "$WALLET_NAMES" | grep -q "^${DESTINATION}$"; then
                NEW_TO_BALANCE=$($CLI_CMD -rpcwallet="$DESTINATION" getbalance 2>/dev/null)
                echo "  $DESTINATION: $NEW_TO_BALANCE JER"
            fi
        else
            echo -e "${RED}Error: Failed to mine block${NC}"
            echo "Transaction is in mempool but not confirmed yet."
        fi
    else
        echo ""
        echo -e "${YELLOW}Transaction is in mempool (unconfirmed)${NC}"
        echo "Mine a block to confirm:"
        echo "  $CLI_CMD generatetoaddress 1 \$($CLI_CMD -rpcwallet=\"$FROM_WALLET\" getnewaddress)"
    fi
fi

echo ""
echo "======================================================================"
