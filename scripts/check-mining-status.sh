#!/bin/bash
# Quick mining status check

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo "======================================================================"
echo "GENESIS MINING STATUS"
echo "======================================================================"
echo ""

# Check if bitcoind is running
if pgrep -f "bitcoind" > /dev/null; then
    PID=$(pgrep -f "bitcoind")
    CPU=$(ps aux | grep bitcoind | grep -v grep | awk '{print $3}')
    MEM=$(ps aux | grep bitcoind | grep -v grep | awk '{print $4}')
    TIME=$(ps -o etime= -p $PID)

    echo -e "${GREEN}✓ Mining in progress${NC}"
    echo ""
    echo "  Process ID:  $PID"
    echo "  CPU Usage:   $CPU%"
    echo "  Memory:      $MEM%"
    echo "  Runtime:     $TIME"
    echo ""

    # Try to estimate progress (very rough)
    # Based on testnet mining: 41.5 minutes for 443M hashes
    # Mainnet should take similar time (same difficulty)
    echo "Estimated completion: 30-60 minutes from start"
    echo "(Based on testnet mining which took 41.5 minutes)"
    echo ""

    # Check if we can see any output
    DEBUG_LOG="$HOME/Library/Application Support/Bitcoin/debug.log"
    if [ -f "$DEBUG_LOG" ]; then
        if grep -q "Mining mainnet" "$DEBUG_LOG" 2>/dev/null; then
            echo -e "${BLUE}Mining log found:${NC}"
            grep "Mining mainnet\|Timestamp\|Bits\|Target" "$DEBUG_LOG" 2>/dev/null
            echo ""
        fi

        # Check for completion
        if grep -q "GENESIS BLOCK FOUND" "$DEBUG_LOG" 2>/dev/null; then
            echo -e "${GREEN}🎉 GENESIS BLOCK FOUND!${NC}"
            echo ""
            grep -A 15 "GENESIS BLOCK FOUND" "$DEBUG_LOG" 2>/dev/null
            echo ""
            echo "Run: ./scripts/monitor-genesis-mining.sh to extract results"
            echo ""
        fi
    fi

    echo "Monitor continuously with:"
    echo "  ./scripts/monitor-genesis-mining.sh"
else
    echo -e "${RED}✗ Mining not running${NC}"
    echo ""

    # Check if it completed
    DEBUG_LOG="$HOME/Library/Application Support/Bitcoin/debug.log"
    if [ -f "$DEBUG_LOG" ] && grep -q "GENESIS BLOCK FOUND" "$DEBUG_LOG" 2>/dev/null; then
        echo -e "${GREEN}✓ Mining completed!${NC}"
        echo ""
        grep -A 15 "GENESIS BLOCK FOUND" "$DEBUG_LOG" 2>/dev/null
        echo ""
        echo "Results saved. Next steps:"
        echo "1. Extract values from above"
        echo "2. Update patches/chainparams.cpp"
        echo "3. Rebuild Jer"
    else
        echo "Mining process not found."
        echo "Start mining with: bitcoind (with mining code in chainparams.cpp)"
    fi
fi

echo ""
echo "======================================================================"
