#!/usr/bin/env python3
"""
Jer Cryptocurrency - Mainnet Genesis Block Miner
Mines a genesis block with proper difficulty (0x1d00ffff)
"""

import hashlib
import struct
import time
from datetime import datetime

# Genesis block parameters for MAINNET
GENESIS_MESSAGE = "Jer 2025 - Empowering global payments"
GENESIS_PUBKEY = "04678afdb0fe5548271967f1a67130b7105cd6a828e03909a67962e0ea1f61deb649f6bc3f4cef38c4f35504e51ec112de5c384df7ba0b8d578a4c702b6bf11d5f"
GENESIS_REWARD = 50 * 100000000  # 50 JER in satoshis
GENESIS_TIME = int(time.time())  # Current timestamp
GENESIS_BITS = 0x1d00ffff  # Bitcoin's original difficulty
GENESIS_VERSION = 1

print("=" * 70)
print("JER CRYPTOCURRENCY - MAINNET GENESIS BLOCK MINER")
print("=" * 70)
print()
print(f"Network:    MAINNET")
print(f"Difficulty: 0x{GENESIS_BITS:08x} (proper Bitcoin difficulty)")
print(f"Message:    {GENESIS_MESSAGE}")
print(f"Timestamp:  {GENESIS_TIME} ({datetime.fromtimestamp(GENESIS_TIME)})")
print(f"Reward:     {GENESIS_REWARD // 100000000} JER")
print()
print("⚠️  WARNING: This will take 2-48 hours depending on your hardware!")
print()
print("Starting in 5 seconds... (Ctrl+C to cancel)")
print()

time.sleep(5)

def create_output_script(pubkey):
    """Create a pay-to-pubkey output script"""
    pubkey_bytes = bytes.fromhex(pubkey)
    script = bytes([len(pubkey_bytes)]) + pubkey_bytes + bytes([0xac])  # OP_CHECKSIG
    return script

def create_coinbase_tx(message, pubkey, value, timestamp):
    """Create coinbase transaction"""
    # Input script (coinbase)
    message_bytes = message.encode('utf-8')
    height_bytes = bytes([0])  # Height 0 for genesis

    # Compact size for scriptsig length
    scriptsig_len = 1 + 4 + 1 + len(message_bytes)
    scriptsig = height_bytes + struct.pack('<I', timestamp) + bytes([len(message_bytes)]) + message_bytes

    # Output script
    output_script = create_output_script(pubkey)

    # Build transaction
    tx = b''
    tx += struct.pack('<I', 1)  # Version
    tx += bytes([1])  # Input count
    tx += bytes(32)  # Previous output (null)
    tx += struct.pack('<I', 0xffffffff)  # Previous output index
    tx += bytes([scriptsig_len])  # Script length
    tx += scriptsig  # Script
    tx += struct.pack('<I', 0xffffffff)  # Sequence
    tx += bytes([1])  # Output count
    tx += struct.pack('<Q', value)  # Output value
    tx += bytes([len(output_script)])  # Script length
    tx += output_script  # Output script
    tx += struct.pack('<I', 0)  # Locktime

    return tx

def double_sha256(data):
    """Double SHA256 hash"""
    return hashlib.sha256(hashlib.sha256(data).digest()).digest()

def calculate_merkle_root(tx):
    """Calculate merkle root from single transaction"""
    return double_sha256(tx)

def bits_to_target(bits):
    """Convert compact bits representation to target"""
    exponent = bits >> 24
    mantissa = bits & 0x00ffffff
    if exponent <= 3:
        target = mantissa >> (8 * (3 - exponent))
    else:
        target = mantissa << (8 * (exponent - 3))
    return target

def mine_block(version, prev_block, merkle_root, timestamp, bits):
    """Mine a block by finding a valid nonce"""
    target = bits_to_target(bits)
    nonce = 0
    start_time = time.time()
    last_update = start_time

    print(f"Mining started at: {datetime.fromtimestamp(start_time)}")
    print(f"Target: {target:064x}")
    print()
    print("Progress:")
    print("-" * 70)

    while nonce < 0xffffffff:
        # Build block header
        header = b''
        header += struct.pack('<I', version)
        header += prev_block
        header += merkle_root
        header += struct.pack('<I', timestamp)
        header += struct.pack('<I', bits)
        header += struct.pack('<I', nonce)

        # Calculate hash
        block_hash = double_sha256(header)
        hash_int = int.from_bytes(block_hash[::-1], 'big')

        # Check if valid
        if hash_int < target:
            elapsed = time.time() - start_time
            hashrate = nonce / elapsed if elapsed > 0 else 0

            print()
            print("=" * 70)
            print("✅ GENESIS BLOCK FOUND!")
            print("=" * 70)
            print()
            print(f"Block Hash:   {block_hash[::-1].hex()}")
            print(f"Merkle Root:  {merkle_root[::-1].hex()}")
            print(f"Timestamp:    {timestamp}")
            print(f"Nonce:        {nonce}")
            print(f"Bits:         0x{bits:08x}")
            print()
            print(f"Mining Time:  {elapsed:.1f} seconds ({elapsed/60:.1f} minutes)")
            print(f"Hashes:       {nonce:,}")
            print(f"Hashrate:     {hashrate:,.0f} H/s ({hashrate/1000:.1f} KH/s)")
            print()

            return block_hash[::-1].hex(), nonce

        nonce += 1

        # Progress update every 10 seconds
        current_time = time.time()
        if current_time - last_update > 10:
            elapsed = current_time - start_time
            hashrate = nonce / elapsed if elapsed > 0 else 0
            progress = (nonce / 0xffffffff) * 100

            print(f"Nonce: {nonce:>12,} | "
                  f"Time: {elapsed:>8.1f}s | "
                  f"Rate: {hashrate/1000:>8.1f} KH/s | "
                  f"Progress: {progress:>6.3f}%")

            last_update = current_time

    print()
    print("❌ Failed to find valid nonce in range 0-4294967295")
    print("   Try incrementing timestamp and mining again")
    return None, None

# Main mining process
print("Step 1: Creating coinbase transaction...")
coinbase_tx = create_coinbase_tx(GENESIS_MESSAGE, GENESIS_PUBKEY, GENESIS_REWARD, GENESIS_TIME)
print(f"✓ Transaction size: {len(coinbase_tx)} bytes")
print()

print("Step 2: Calculating merkle root...")
merkle_root = calculate_merkle_root(coinbase_tx)
print(f"✓ Merkle root: {merkle_root[::-1].hex()}")
print()

print("Step 3: Mining genesis block...")
print("   This will take 2-48 hours depending on luck and hardware...")
print()

prev_block = bytes(32)  # All zeros for genesis
block_hash, nonce = mine_block(GENESIS_VERSION, prev_block, merkle_root, GENESIS_TIME, GENESIS_BITS)

if block_hash:
    # Prepare output content
    output = []
    output.append("=" * 70)
    output.append("JER CRYPTOCURRENCY - MAINNET GENESIS BLOCK")
    output.append("=" * 70)
    output.append("")
    output.append(f"Mined at: {datetime.now()}")
    output.append("")
    output.append("GENESIS BLOCK DETAILS:")
    output.append("-" * 70)
    output.append(f"Block Hash:   {block_hash}")
    output.append(f"Merkle Root:  {merkle_root[::-1].hex()}")
    output.append(f"Timestamp:    {GENESIS_TIME}")
    output.append(f"Nonce:        {nonce}")
    output.append(f"Bits:         0x{GENESIS_BITS:08x}")
    output.append(f"Version:      {GENESIS_VERSION}")
    output.append(f"Message:      {GENESIS_MESSAGE}")
    output.append("")
    output.append("=" * 70)
    output.append("UPDATE chainparams.cpp WITH THESE VALUES:")
    output.append("=" * 70)
    output.append("")
    output.append("// Mainnet genesis block (Line ~138-143)")
    output.append(f"genesis = CreateGenesisBlock({GENESIS_TIME}, {nonce}, 0x{GENESIS_BITS:08x}, {GENESIS_VERSION}, {GENESIS_REWARD // 100000000} * COIN);")
    output.append(f'assert(genesis.GetHash() == uint256S("0x{block_hash}"));')
    output.append(f'assert(genesis.hashMerkleRoot == uint256S("0x{merkle_root[::-1].hex()}"));')
    output.append("")
    output.append("=" * 70)
    output.append("NEXT STEPS:")
    output.append("=" * 70)
    output.append("1. Update patches/chainparams.cpp with these values")
    output.append("2. Run: ./scripts/sync-patches.sh")
    output.append("3. Run: ./scripts/build-jer.sh")
    output.append("4. Test before launching publicly!")
    output.append("")

    # Save to file
    output_file = "mainnet-genesis-result.txt"
    with open(output_file, 'w') as f:
        f.write('\n'.join(output))

    # Print to console
    print("=" * 70)
    print("UPDATE chainparams.cpp WITH THESE VALUES:")
    print("=" * 70)
    print()
    print("// Mainnet genesis block (Line ~138-143)")
    print(f"genesis = CreateGenesisBlock({GENESIS_TIME}, {nonce}, 0x{GENESIS_BITS:08x}, {GENESIS_VERSION}, {GENESIS_REWARD // 100000000} * COIN);")
    print(f'assert(genesis.GetHash() == uint256S("0x{block_hash}"));')
    print(f'assert(genesis.hashMerkleRoot == uint256S("0x{merkle_root[::-1].hex()}"));')
    print()
    print("=" * 70)
    print()
    print("⚠️  IMPORTANT:")
    print("1. Update patches/chainparams.cpp with these values")
    print("2. Run: ./scripts/sync-patches.sh")
    print("3. Run: ./scripts/build-jer.sh")
    print("4. Test before launching publicly!")
    print()
    print(f"✅ Results saved to: {output_file}")
    print()
else:
    print()
    print("Mining failed. This is very unlikely but can happen.")
    print("Try running the script again (it will use a new timestamp).")
