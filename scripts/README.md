# Jer Cryptocurrency Scripts

Essential scripts for building and running Jer cryptocurrency.

## Build Script

### `build-jer.sh`
Builds Jer cryptocurrency from Bitcoin Core source using CMake.

**Usage:**
```bash
./scripts/build-jer.sh
```

**What it does:**
- Configures Bitcoin Core with CMake (Release build, no GUI, wallet enabled)
- Builds all binaries (bitcoind, bitcoin-cli, bitcoin-tx, bitcoin-wallet)
- Places binaries in `bitcoin-core/build/bin/`

---

## Node Management Scripts

### `start-regtest.sh`
Starts Jer node in regtest (development) mode with a clean slate.

**Usage:**
```bash
./scripts/start-regtest.sh
```

**What it does:**
- Cleans old regtest data
- Starts bitcoind daemon in regtest mode
- Displays genesis block hash and blockchain info
- Shows useful commands for interacting with the node

### `stop-node.sh`
Stops a running Jer node.

**Usage:**
```bash
./scripts/stop-node.sh [regtest|testnet|mainnet]
```

**Examples:**
```bash
./scripts/stop-node.sh              # Stops regtest (default)
./scripts/stop-node.sh testnet      # Stops testnet
./scripts/stop-node.sh mainnet      # Stops mainnet
```

---

## Testing Scripts

### `test-mining.sh`
Tests mining functionality on regtest network.

**Usage:**
```bash
./scripts/test-mining.sh
```

**What it does:**
1. Creates a test wallet
2. Generates a new address
3. Mines 101 blocks (to mature the first reward)
4. Displays balance and mining results

**Requirements:** Node must be running (use `start-regtest.sh` first)

---

## Wallet Management

### `wallet-guide.sh`
Interactive guide showing all wallet commands and current wallet status.

**Usage:**
```bash
./scripts/wallet-guide.sh [regtest|testnet|mainnet]
```

**Examples:**
```bash
./scripts/wallet-guide.sh           # Show regtest wallet info
./scripts/wallet-guide.sh testnet   # Show testnet wallet info
```

**What it shows:**
- Complete list of wallet commands
- Current loaded wallets
- Current balance
- Wallet data directory location

---

## Quick Start Workflow

1. **Build Jer cryptocurrency:**
   ```bash
   ./scripts/build-jer.sh
   ```

2. **Start regtest node:**
   ```bash
   ./scripts/start-regtest.sh
   ```

3. **Test mining:**
   ```bash
   ./scripts/test-mining.sh
   ```

4. **Check wallet:**
   ```bash
   ./scripts/wallet-guide.sh
   ```

5. **Stop node:**
   ```bash
   ./scripts/stop-node.sh
   ```

---

## Direct Wallet Access

You can also access the wallet directly using `bitcoin-cli`:

```bash
# Set the CLI path
CLI="bitcoin-core/build/bin/bitcoin-cli -regtest"

# Create wallet
$CLI createwallet "mywallet"

# Get balance
$CLI getbalance

# Get new address
$CLI getnewaddress

# Send JER
$CLI sendtoaddress <address> <amount>

# List transactions
$CLI listtransactions

# View wallet info
$CLI getwalletinfo
```

---

## Wallet File Locations

Your wallet files are stored in:

- **Regtest:** `~/Library/Application Support/Bitcoin/regtest/wallets/`
- **Testnet:** `~/Library/Application Support/Bitcoin/testnet3/wallets/`
- **Mainnet:** `~/Library/Application Support/Bitcoin/wallets/`

**Important:** These are the actual wallet files containing your private keys. Back them up securely!

---

## Common Wallet Commands

### Create Wallet
```bash
bitcoin-cli -regtest createwallet "mywallet"
```

### List Wallets
```bash
bitcoin-cli -regtest listwallets
```

### Get Balance
```bash
bitcoin-cli -regtest getbalance
```

### Get New Address
```bash
bitcoin-cli -regtest getnewaddress
```

### Send JER
```bash
bitcoin-cli -regtest sendtoaddress "bcrt1q..." 10.5
```

### List Transactions
```bash
bitcoin-cli -regtest listtransactions
```

### Backup Wallet
```bash
bitcoin-cli -regtest backupwallet "/path/to/backup.dat"
```

### Export Private Key
```bash
# First get address
bitcoin-cli -regtest dumpprivkey "bcrt1q..."
```

---

## Troubleshooting

### Node won't start
Check the debug log:
```bash
tail -f ~/Library/Application\ Support/Bitcoin/regtest/debug.log
```

### Wallet issues
List and reload wallet:
```bash
bitcoin-cli -regtest listwallets
bitcoin-cli -regtest loadwallet "mywallet"
```

### Clean restart
```bash
./scripts/stop-node.sh
rm -rf ~/Library/Application\ Support/Bitcoin/regtest
./scripts/start-regtest.sh
```
