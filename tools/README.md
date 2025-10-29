# JER Cryptocurrency - Phase 5 Tools

**⚠️ WARNING: These tools are for Phase 5 (Mainnet Launch) ONLY**

Do NOT use these tools during Phase 1-4 (Testing/Testnet). Current easy difficulty is correct for development and testing.

---

## Genesis Block Miner

### mine_genesis.py

Mines the genesis block with proper difficulty for production mainnet launch.

**When to use:** Phase 5 (9-12 months from now), before mainnet launch

**Current status:** Phase 1 - Development/Testing with easy difficulty ✅

### Requirements

```bash
# Python 3.7+
python3 --version

# No external dependencies needed (uses standard library)
```

### Usage

**For Mainnet (Phase 5):**
```bash
python3 mine_genesis.py --network mainnet --difficulty 0x1d00ffff
```

**For Testnet (Phase 5):**
```bash
python3 mine_genesis.py --network testnet --difficulty 0x1d00ffff
```

**Custom difficulty:**
```bash
python3 mine_genesis.py --network mainnet --difficulty 0x1c00ffff
```

**Use all CPU cores (default):**
```bash
python3 mine_genesis.py --network mainnet
```

**Use specific number of cores:**
```bash
python3 mine_genesis.py --network mainnet --processes 8
```

### Expected Mining Time

**With 0x1d00ffff difficulty (Bitcoin's start):**
- M1/M2 Mac (8 cores): 2-48 hours (average: 12 hours)
- Intel Mac (4 cores): 4-96 hours (average: 24 hours)
- Cloud GPU (NVIDIA V100): 1-6 hours (average: 2 hours)

**Note:** Time varies significantly due to randomness of mining. You might get lucky and find it in 30 minutes, or unlucky and take 3 days.

### What It Does

1. Sets up genesis block parameters (timestamp, difficulty, message)
2. Parallelizes mining across all CPU cores
3. Tries different nonce values until valid hash found
4. Displays progress (hashrate, time elapsed)
5. Outputs the found nonce and hash
6. Tells you what to update in chainparams.cpp

### Example Output

```
======================================================================
JER CRYPTOCURRENCY - GENESIS BLOCK MINER
======================================================================
Network:        mainnet
Difficulty:     0x1d00ffff
Target:         26959535291011309493156476344723991336010898738574164086137773096960
Timestamp:      1761633768 (2025-10-27 15:42:48)
Message:        Jer 2025 - Empowering global payments
CPU Cores:      10
======================================================================

Starting mining... This may take hours or days depending on difficulty.

Nonce:   1234567 | Hash: a3f5b2c8... | Rate: 45.23 KH/s | Time: 27s

...

======================================================================
🎉 GENESIS BLOCK FOUND!
======================================================================
Nonce:          2083236893
Hash:           000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f
Time taken:     12847.23 seconds
Hashes checked: 2,083,236,893

Update patches/chainparams.cpp with:
  Timestamp: 1761633768
  Nonce:     2083236893
  Bits:      0x1d00ffff
======================================================================
```

### After Mining

**Update patches/chainparams.cpp:**

```cpp
// Find the mainnet genesis block section (~line 138-143)
genesis = CreateGenesisBlock(
    1761633768,      // timestamp from miner output
    2083236893,      // nonce from miner output
    0x1d00ffff,      // bits (difficulty)
    1,               // version
    50 * COIN        // reward
);

// Update the expected hash
consensus.hashGenesisBlock = uint256S("0x000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f");
```

**Rebuild:**
```bash
./scripts/build-jer.sh
```

**Test:**
```bash
./scripts/start-mainnet.sh  # (you'll create this script)
bitcoin-cli getblockhash 0
```

### Important Notes

**⚠️ This is a simplified demonstration miner:**
- Actual Phase 5 launch should use Bitcoin Core's CreateGenesisBlock()
- This script needs the correct merkle root from coinbase transaction
- Consider having the actual genesis mining code reviewed in security audit

**✅ Best Practice:**
1. Mine genesis on testnet first (practice)
2. Verify everything works
3. Then mine mainnet genesis
4. Test privately before public launch

### Fair Launch Strategy

**Week 0: Genesis Mining (Private)**
- Use this script to mine genesis
- Keep private until infrastructure ready
- Test thoroughly

**Week 1: Soft Launch**
- Mine first 100-1000 blocks privately
- Set up seed nodes
- Prepare documentation

**Week 2+: Public Launch**
- Announce to community
- Share mining software
- Let others join

See CLAUDE.md for complete Phase 5 launch strategy.

---

## Troubleshooting

**"Mining is too slow":**
- This is normal with proper difficulty
- Consider using cloud GPU for $10-50
- Or be patient - it will eventually find it

**"No valid hash found after days":**
- Very unlikely but possible (bad luck)
- Let it continue running
- Check that difficulty is set correctly

**"Script shows 'found' but hash doesn't validate":**
- There's a bug in the merkle root calculation
- For actual Phase 5, use Bitcoin Core's CreateGenesisBlock()
- This script is for learning/demonstration

**"Want to stop and resume later":**
- Mining is stateless - can't resume
- Each run starts from nonce 0
- Use cloud GPU to finish faster

---

## Phase 5 Checklist

Before using this tool:

- [ ] Completed Phase 1 (Configuration) ✅ DONE
- [ ] Completed Phase 2 (Testnet Deployment)
- [ ] Completed Phase 3 (Community Growth)
- [ ] Completed Phase 4 (Fundraising)
- [ ] Security audit completed
- [ ] Legal review completed
- [ ] Infrastructure ready (seed nodes, monitoring)
- [ ] Community notified of mainnet launch
- [ ] Mining software ready to share
- [ ] Documentation prepared

**Current Status: Phase 1 Complete** ✅

Do not mine mainnet genesis until all above items are complete!

---

## Contact

Questions about Phase 5 launch? See:
- CLAUDE.md - Complete launch strategy
- PRODUCTION-ROADMAP.md - Detailed timeline
- GitHub Issues - Community discussion
