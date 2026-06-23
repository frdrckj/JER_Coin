# JER Cryptocurrency

**A Bitcoin Core–based cryptocurrency with custom network configuration**

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

---

## 🎯 Overview

JER is a cryptocurrency built on Bitcoin Core with custom network parameters, a unique bech32 address prefix, and freshly mined genesis blocks. It tracks upstream Bitcoin Core and patches a single file — `chainparams.cpp` — so the consensus rules and economics are Bitcoin's, while the network identity is JER's own.

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
- ✅ **Bech32 Addresses**: Native SegWit address format (jer1... / tjer1...)
- ✅ **Freshly Mined Genesis**: New genesis blocks mined for mainnet, testnet, and regtest
- ✅ **Proven Economics**: Bitcoin's tested model (21M supply, 50 JER block reward)
- ✅ **CMake Build**: Modern build system, with Linux and macOS CI

---

## 🚀 Quick Start

### Prerequisites

- macOS or Linux
- CMake and a C++20-capable compiler (as required by current Bitcoin Core)
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
- Clones Bitcoin Core from the official repository
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
Base:               Bitcoin Core (upstream master)
Build System:       CMake
Consensus:          Proof of Work (SHA-256) — inherited from Bitcoin
Address Format:     Bech32 (native SegWit)
```

---

## 🛠️ Development

### Project Structure

```
JER_Coin/
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
└── bitcoin-core/          # Bitcoin Core (cloned by setup.sh, not in git)
```

### Key Modifications

All modifications live in `patches/chainparams.cpp`, applied over Bitcoin Core by `setup.sh`:

- **Mainnet**: magic bytes `JERU`, P2P port `8732`, bech32 HRP `jer`, freshly mined genesis block
- **Testnet**: magic bytes `JERT`, P2P port `18732`, bech32 HRP `tjer`, freshly mined genesis block
- **Regtest**: freshly mined genesis block (network params otherwise Bitcoin defaults)

**Note**: Only `chainparams.cpp` is modified — consensus rules, economics, and the rest of Bitcoin Core are unchanged. Legacy (base58) address prefixes remain Bitcoin's defaults; only the bech32 prefix is JER-specific.

---
