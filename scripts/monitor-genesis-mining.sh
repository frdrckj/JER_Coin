#!/bin/bash
# Monitor mainnet genesis mining progress

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

RESULT_FILE="mainnet-genesis-bitcoincore-result.txt"
CHECK_INTERVAL=60  # Check every 60 seconds

echo "======================================================================"
echo "JER CRYPTOCURRENCY - GENESIS MINING MONITOR"
echo "======================================================================"
echo ""
echo -e "${BLUE}Monitoring genesis mining process...${NC}"
echo "Results will be saved to: $RESULT_FILE"
echo ""
echo "Press Ctrl+C to stop monitoring (mining will continue)"
echo ""

# Function to check if mining is still running
check_mining() {
    if pgrep -f "bitcoind" > /dev/null; then
        return 0  # Still running
    else
        return 1  # Completed or stopped
    fi
}

# Function to extract results from stdout or debug log
extract_results() {
    # Try to find the results in debug.log
    DEBUG_LOG="$HOME/Library/Application Support/Bitcoin/debug.log"

    if [ -f "$DEBUG_LOG" ]; then
        # Check if genesis was found
        if grep -q "GENESIS BLOCK FOUND" "$DEBUG_LOG" 2>/dev/null; then
            echo "Found genesis block in debug log!"

            # Extract the important lines
            grep -A 20 "GENESIS BLOCK FOUND" "$DEBUG_LOG" > "$RESULT_FILE"

            return 0
        fi
    fi

    return 1
}

# Main monitoring loop
START_TIME=$(date +%s)
LAST_STATUS=""

while true; do
    CURRENT_TIME=$(date +%s)
    ELAPSED=$((CURRENT_TIME - START_TIME))
    HOURS=$((ELAPSED / 3600))
    MINUTES=$(((ELAPSED % 3600) / 60))
    SECONDS=$((ELAPSED % 60))

    if check_mining; then
        # Still mining
        CPU_USAGE=$(ps aux | grep bitcoind | grep -v grep | awk '{print $3}')

        STATUS="⛏️  Mining in progress... | Elapsed: ${HOURS}h ${MINUTES}m ${SECONDS}s | CPU: ${CPU_USAGE}%"

        if [ "$STATUS" != "$LAST_STATUS" ]; then
            echo -e "${YELLOW}$STATUS${NC}"
            LAST_STATUS="$STATUS"
        fi

        sleep $CHECK_INTERVAL
    else
        # Mining stopped - check if we found the genesis
        echo ""
        echo -e "${GREEN}Mining process stopped!${NC}"
        echo ""

        if extract_results; then
            echo -e "${GREEN}✓ Genesis block found!${NC}"
            echo ""
            echo "======================================================================"
            cat "$RESULT_FILE"
            echo "======================================================================"
            echo ""
            echo -e "${GREEN}Results saved to: $RESULT_FILE${NC}"
            echo ""
            echo "Next steps:"
            echo "1. Review the results in $RESULT_FILE"
            echo "2. Update patches/chainparams.cpp with the values"
            echo "3. Run: ./scripts/sync-patches.sh"
            echo "4. Run: ./scripts/build-jer.sh"
            echo "5. Test your mainnet!"

            # Also try to get output from background bash
            echo ""
            echo "If mining completed successfully, the values are shown above."

            exit 0
        else
            echo -e "${YELLOW}⚠ Mining stopped but no results found in debug.log${NC}"
            echo ""
            echo "This might mean:"
            echo "  1. Mining is still initializing (wait a bit and run this script again)"
            echo "  2. Mining failed (check debug.log manually)"
            echo "  3. Results were written elsewhere"
            echo ""
            echo "Check manually:"
            echo "  tail -100 ~/Library/Application\\ Support/Bitcoin/debug.log"

            exit 1
        fi
    fi
done
