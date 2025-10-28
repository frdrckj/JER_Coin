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

# Build using provided script
./scripts/build-jer.sh
```

Build takes 10-30 minutes depending on your hardware.

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

### Economic Parameters

```
Block Reward:       50 JER
Halving Interval:   210,000 blocks (~4 years)
Maximum Supply:     21,000,000 JER
Block Time:         10 minutes (target)
Difficulty Adjust:  Every 2,016 blocks (~2 weeks)
```

### Technical Details

```
Base:               Bitcoin Core v30+
Build System:       CMake
Consensus:          Proof of Work (SHA-256)
Address Format:     Bech32 (native SegWit)
```

---

## 📚 Documentation

- **[CLAUDE.md](CLAUDE.md)** - Quick context and project state
- **[CONFIGURATION-COMPLETE.md](CONFIGURATION-COMPLETE.md)** - Configuration status and next steps
- **[NETWORK-CONFIGURATION.md](NETWORK-CONFIGURATION.md)** - Complete network technical details
- **[YOUR-PRODUCTION-PLAN.md](YOUR-PRODUCTION-PLAN.md)** - Production deployment roadmap
- **[BUILD-SUCCESS-SUMMARY.md](BUILD-SUCCESS-SUMMARY.md)** - Build history and verification

---

## 🛠️ Development

### Project Structure

```
jer-cryptocurrency/
├── bitcoin-core/          # Bitcoin Core source with JER modifications
│   ├── src/
│   │   └── kernel/
│   │       └── chainparams.cpp   # Network configuration
│   └── build/             # Build artifacts (not in git)
├── scripts/               # Helper scripts
│   ├── build-jer.sh      # Build script
│   ├── start-regtest.sh  # Start local test network
│   ├── stop-node.sh      # Stop any node
│   ├── test-mining.sh    # Test mining functionality
│   └── wallet-guide.sh   # Wallet command reference
└── docs/                  # Documentation (various .md files)
```

### Key Modifications

All modifications are in `bitcoin-core/src/kernel/chainparams.cpp`:

- **Lines 130-134**: Mainnet magic bytes (JERU) and port (8732)
- **Line 162**: Mainnet bech32 prefix (jer)
- **Lines 248-253**: Testnet magic bytes (JERT) and port (18732)
- **Line 277**: Testnet bech32 prefix (tjer)

---

## 🔧 Configuration

### Network Configuration

The network is configured with unique parameters to prevent conflicts:

```cpp
// Mainnet
Magic Bytes: 0x4a455255 (JERU)
Port:        8732
Prefix:      jer1

// Testnet
Magic Bytes: 0x4a455254 (JERT)
Port:        18732
Prefix:      tjer1
```

### Genesis Blocks

Custom genesis blocks for all networks:

```
Mainnet:  47a8ab4e7af4ae494bfb35503a7f8e49fd309876b2765a0fc225f99478d923c0
Testnet:  7ef5fad34553266ff67470ce8876aa90895f39be8b78ed301c184ac8934cfd41
Regtest:  23ed3a57f87b65a0b4a50e820eefa73b16530dbca359e0803d55843a8238d96e
```

---

## 🌐 Network Status

### Current Phase: Configuration Complete ✅

- ✅ Network parameters configured
- ✅ Build system working
- ✅ Local testing verified
- ✅ Documentation complete

### Next Phase: Testnet Deployment

See [CONFIGURATION-COMPLETE.md](CONFIGURATION-COMPLETE.md) for the deployment roadmap.

---

## ⚠️ Important Notices

### Development Status

**This is experimental software. Use at your own risk.**

- ⚠️ **Not production-ready**: Current genesis uses easy difficulty
- ⚠️ **No security audit**: Has not been professionally audited
- ⚠️ **No legal review**: Regulatory compliance not verified
- ⚠️ **Testnet first**: Start with testnet before considering mainnet

### Security

- 🔒 Never share private keys or wallet files
- 🔒 Always use testnet for experimentation
- 🔒 Keep recovery seeds offline and secure
- 🔒 Enable 2FA on all accounts

---

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. **Test**: Run regtest and report issues
2. **Document**: Improve documentation
3. **Code Review**: Review code changes
4. **Community**: Join discussions and help others

### Development Workflow

```bash
# Fork the repository
# Create a feature branch
git checkout -b feature/your-feature

# Make changes and test
./scripts/build-jer.sh
./scripts/start-regtest.sh

# Commit and push
git commit -m "Description of changes"
git push origin feature/your-feature

# Open a Pull Request
```

---

## 📝 License

This project is based on Bitcoin Core and inherits its MIT License.

See [LICENSE](LICENSE) for details.

---

## 🔗 Links

- **Repository**: https://github.com/frdrckj/JER_Coin
- **Issues**: https://github.com/frdrckj/JER_Coin/issues
- **Discussions**: https://github.com/frdrckj/JER_Coin/discussions

---

## 💬 Community

Join the JER community:

- **Discord**: [Coming Soon]
- **Telegram**: [Coming Soon]
- **Twitter**: [Coming Soon]

---

## 📞 Support

- **Documentation**: Check the docs/ folder
- **Issues**: Open an issue on GitHub
- **Security**: Email security concerns privately

---

## 🙏 Acknowledgments

- **Bitcoin Core**: Built on the shoulders of giants
- **Community**: Thanks to all testers and contributors

---

## 📈 Roadmap

### Phase 1: Configuration ✅ (Complete)
- Network parameters
- Build system
- Local testing

### Phase 2: Testnet (Next)
- Deploy seed nodes
- Community launch
- Thorough testing

### Phase 3: Community Growth
- Build user base
- Gather feedback
- Continuous improvement

### Phase 4: Production (Future)
- Security audit
- Legal review
- Mainnet launch

---

**Built with ❤️ by the JER community**

