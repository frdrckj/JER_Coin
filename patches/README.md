# JER Cryptocurrency Patches

This directory contains modifications to Bitcoin Core source code that create the JER cryptocurrency.

## Files

### `chainparams.cpp`
Modified version of `bitcoin-core/src/kernel/chainparams.cpp`

**Key Changes:**

#### Mainnet (Lines 130-134, 162)
- Magic bytes: `0x4a455255` (JERU)
- Port: `8732`
- Bech32 prefix: `jer`
- Genesis hash: `47a8ab4e7af4ae494bfb35503a7f8e49fd309876b2765a0fc225f99478d923c0`

#### Testnet (Lines 248-253, 277)
- Magic bytes: `0x4a455254` (JERT)
- Port: `18732`
- Bech32 prefix: `tjer`
- Genesis hash: `7ef5fad34553266ff67470ce8876aa90895f39be8b78ed301c184ac8934cfd41`

#### Regtest (Lines 619-624)
- Genesis hash: `23ed3a57f87b65a0b4a50e820eefa73b16530dbca359e0803d55843a8238d96e`

## Applying Patches

The `setup.sh` script in the project root will:
1. Clone Bitcoin Core (if not present)
2. Copy this modified `chainparams.cpp` to the correct location
3. You're ready to build!

## Manual Application

If you prefer to apply manually:

```bash
# From project root
cp patches/chainparams.cpp bitcoin-core/src/kernel/chainparams.cpp
```

## Viewing Changes

To see what changed from Bitcoin Core:

```bash
cd bitcoin-core
git diff src/kernel/chainparams.cpp
```

This will show all JER-specific modifications.

## Bitcoin Core Version

These patches are based on Bitcoin Core v30.99.0 (master branch as of October 2025).

## Notes

- Only `chainparams.cpp` is modified
- All other Bitcoin Core code remains unchanged
- Economic parameters match Bitcoin (21M supply, 50 coin reward, etc.)
- Only network identity is different (JERU/JERT magic bytes, custom ports, jer1/tjer1 addresses)
