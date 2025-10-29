#!/bin/bash
# Codespace setup script for Jer Cryptocurrency testnet node

echo "========================================================================"
echo "Setting up Jer Cryptocurrency Testnet Node in Codespace"
echo "========================================================================"
echo ""

# Update package list
echo "Updating package list..."
sudo apt-get update

# Install dependencies
echo "Installing dependencies..."
sudo apt-get install -y \
    build-essential \
    cmake \
    git \
    libtool \
    autotools-dev \
    automake \
    pkg-config \
    bsdmainutils \
    python3 \
    libevent-dev \
    libboost-dev \
    libsqlite3-dev \
    libzmq3-dev \
    systemtap-sdt-dev

echo ""
echo "✓ Dependencies installed"
echo ""

# Clone Bitcoin Core if not already present
if [ ! -d "bitcoin-core" ]; then
    echo "Cloning Bitcoin Core..."
    git clone --branch v30.0 --depth 1 https://github.com/bitcoin/bitcoin.git bitcoin-core
    echo "✓ Bitcoin Core cloned"
else
    echo "✓ Bitcoin Core already present"
fi

# Apply Jer patches
echo ""
echo "Applying Jer patches..."
if [ -f "patches/chainparams.cpp" ]; then
    cp patches/chainparams.cpp bitcoin-core/src/kernel/chainparams.cpp
    echo "✓ Patches applied"
else
    echo "⚠ Warning: patches/chainparams.cpp not found"
fi

echo ""
echo "========================================================================"
echo "Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Build Jer: ./scripts/build-jer.sh"
echo "  2. Start testnet: ./scripts/start-testnet.sh"
echo "========================================================================"
echo ""
