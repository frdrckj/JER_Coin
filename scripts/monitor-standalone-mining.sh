#!/bin/bash
# Monitor standalone genesis mining progress

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

RESULT_FILE="../mainnet-genesis-standalone-result.txt"

echo "======================================================================"
echo "MONITORING STANDALONE GENESIS MINING"
echo "======================================================================"
echo ""

# Check if mining process is running
if pgrep -f "mine-genesis" > /dev/null; then
    PID=$(pgrep -f "mine-genesis")
    echo -e "${GREEN}✓ Mining in progress${NC}"
    echo "  Process ID: $PID"
    echo ""

    if [ -f "$RESULT_FILE" ]; then
        echo "Latest progress:"
        tail -1 "$RESULT_FILE"
        echo ""

        # Check if completed
        if grep -q "GENESIS BLOCK FOUND" "$RESULT_FILE" 2>/dev/null; then
            echo -e "${GREEN}🎉 MINING COMPLETED!${NC}"
            echo ""
            grep -A 20 "GENESIS BLOCK FOUND" "$RESULT_FILE"
            echo ""
            echo -e "${GREEN}Results saved to: $RESULT_FILE${NC}"
        else
            echo "Mining continues... Check status with:"
            echo "  tail -f $RESULT_FILE"
        fi
    else
        echo "No output file yet. Mining may be starting..."
    fi
else
    echo -e "${YELLOW}✗ Mining not running${NC}"

    if [ -f "$RESULT_FILE" ] && grep -q "GENESIS BLOCK FOUND" "$RESULT_FILE" 2>/dev/null; then
        echo -e "${GREEN}✓ Mining completed!${NC}"
        echo ""
        grep -A 20 "GENESIS BLOCK FOUND" "$RESULT_FILE"
    else
        echo "Mining process not found. Start with:"
        echo "  cd scripts && ./mine-genesis > ../mainnet-genesis-standalone-result.txt 2>&1 &"
    fi
fi

echo ""
echo "======================================================================"
