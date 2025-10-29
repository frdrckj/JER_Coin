# JER Cryptocurrency

**A Bitcoin-based cryptocurrency with custom network configuration**

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)]()
[![Network](https://img.shields.io/badge/network-configured-success.svg)]()

---

## 🎯 Overview

JER is a cryptocurrency built on Bitcoin Core v30+ with custom network parameters, unique address prefixes, and dedicated network infrastructure.

### Network Identity

| Network | Magic Bytes | Port | Address Prefix | Status |
|---------|-------------|------|----------------|--------|
| **Mainnet** | `JERU` (0x4a455255) | 8732 | `jer1...` | Configured |
| **Testnet** | `JERT` (0x4a455254) | 18732 | `tjer1...` | Configured |
| **Regtest** | Bitcoin default | 18444 | `bcrt1...` | Active |

---

## ✨ Features

- ✅ **Unique Network**: Custom magic bytes (JERU/JERT) separate from Bitcoin
- ✅ **Custom Ports**: No conflicts with Bitcoin or other cryptocurrencies
- ✅ **Bech32 Addresses**: Modern address format (jer1... / tjer1...)
- ✅ **Proven Economics**: Bitcoin's tested model (21M supply, 50 JER reward)
- ✅ **CMake Build**: Modern build system
- ✅ **Fully Documented**: Complete configuration and deployment guides

---

## 🚀 Quick Start

### Prerequisites

- macOS, Linux, or Windows WSL
- CMake 3.16+
- C++17 compiler
- Standard build tools

### Build from Source

```bash
# Clone the repository
git clone https://github.com/frdrckj/JER_Coin.git
cd JER_Coin

# Run setup script (clones Bitcoin Core and applies JER patches)
./setup.sh

# Build using provided script
./scripts/build-jer.sh
```


**What `setup.sh` does:**
- Clones Bitcoin Core from official repository
- Applies JER modifications (custom network parameters)
- Checks for required dependencies
- Prepares the build environment

### Run Regtest (Local Testing)

```bash
# Start local test network
./scripts/start-regtest.sh

# Test mining
./scripts/test-mining.sh

# Access wallet
./scripts/wallet-guide.sh

# Stop node
./scripts/stop-node.sh
```

---

## 📊 Specifications

### Technical Details

```
Base:               Bitcoin Core v30+
Build System:       CMake
Consensus:          Proof of Work (SHA-256)
Address Format:     Bech32 (native SegWit)
```

---

## 🛠️ Development

### Project Structure

```
jer-cryptocurrency/
├── patches/               # JER modifications to Bitcoin Core
│   ├── chainparams.cpp   # Modified network configuration
│   └── README.md         # Patch documentation
├── scripts/               # Helper scripts
│   ├── build-jer.sh      # Build script
│   ├── start-regtest.sh  # Start local test network
│   ├── stop-node.sh      # Stop any node
│   ├── test-mining.sh    # Test mining functionality
│   └── wallet-guide.sh   # Wallet command reference
├── setup.sh               # Setup script (clones Bitcoin Core, applies patches)
├── bitcoin-core/          # Bitcoin Core (cloned by setup.sh, not in git)
└── docs/                  # Documentation (various .md files)
```

### Key Modifications

All modifications are in `patches/chainparams.cpp` (applied to Bitcoin Core):

- **Lines 130-134**: Mainnet magic bytes (JERU) and port (8732)
- **Line 162**: Mainnet bech32 prefix (jer)
- **Lines 248-253**: Testnet magic bytes (JERT) and port (18732)
- **Line 277**: Testnet bech32 prefix (tjer)

**Note**: Only `chainparams.cpp` is modified. All other Bitcoin Core code remains unchanged.

---
