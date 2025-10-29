#!/usr/bin/env python3
"""
JER Cryptocurrency - Genesis Block Miner
Phase 5 Tool - Use when ready to launch mainnet with proper difficulty

This script mines the genesis block with proper difficulty (0x1d00ffff)
for production mainnet launch.

Usage:
    python3 mine_genesis.py --network mainnet --difficulty 0x1d00ffff
    python3 mine_genesis.py --network testnet --difficulty 0x1d00ffff

DO NOT USE THIS YET! This is for Phase 5 (9-12 months from now)
Current Phase 1-4 uses easy difficulty for testing.
"""

import hashlib
import struct
import time
import multiprocessing
from datetime import datetime
import argparse

# Network messages
MESSAGES = {
    'mainnet': b'Jer 2025 - Empowering global payments',
    'testnet': b'Jer Testnet 2025 - Testing the future',
    'regtest': b'Jer Regtest - Development network'
}

class GenesisBlockMiner:
    def __init__(self, network='mainnet', difficulty=0x1d00ffff):
        self.network = network
        self.difficulty = difficulty
        self.message = MESSAGES.get(network, MESSAGES['mainnet'])
        self.version = 1
        self.prev_block = b'\x00' * 32
        self.timestamp = int(time.time())
        self.bits = difficulty

    def compact_to_target(self, bits):
        """Convert compact difficulty representation to target hash"""
        exponent = bits >> 24
        mantissa = bits & 0xffffff
        if exponent <= 3:
            target = mantissa >> (8 * (3 - exponent))
        else:
            target = mantissa << (8 * (exponent - 3))
        return target

    def hash_genesis_block(self, nonce):
        """Hash a genesis block with given nonce"""
        # Bitcoin genesis block header format:
        # version (4 bytes) + prev_block (32 bytes) + merkle_root (32 bytes) +
        # timestamp (4 bytes) + bits (4 bytes) + nonce (4 bytes)

        # For genesis, we need to create the coinbase transaction first
        # Then calculate its merkle root
        # This is a simplified version - actual implementation should match
        # Bitcoin Core's CreateGenesisBlock() exactly

        # Build block header
        header = struct.pack('<I', self.version)
        header += self.prev_block
        # Merkle root would go here (calculated from coinbase tx)
        # For now, using placeholder - actual miner needs real merkle root
        header += b'\x00' * 32  # Placeholder merkle root
        header += struct.pack('<I', self.timestamp)
        header += struct.pack('<I', self.bits)
        header += struct.pack('<I', nonce)

        # Double SHA-256
        hash_result = hashlib.sha256(hashlib.sha256(header).digest()).digest()
        return hash_result

    def check_hash(self, hash_bytes):
        """Check if hash meets difficulty target"""
        hash_int = int.from_bytes(hash_bytes, byteorder='little')
        target = self.compact_to_target(self.bits)
        return hash_int < target

    def mine_worker(self, start_nonce, end_nonce, result_queue):
        """Worker process for parallel mining"""
        for nonce in range(start_nonce, end_nonce):
            if nonce % 100000 == 0:
                # Progress update
                hash_result = self.hash_genesis_block(nonce)
                result_queue.put(('progress', nonce, hash_result))

            hash_result = self.hash_genesis_block(nonce)
            if self.check_hash(hash_result):
                result_queue.put(('found', nonce, hash_result))
                return

        result_queue.put(('done', start_nonce, end_nonce))

    def mine(self, num_processes=None):
        """Mine genesis block using multiple processes"""
        if num_processes is None:
            num_processes = multiprocessing.cpu_count()

        print("=" * 70)
        print(f"JER CRYPTOCURRENCY - GENESIS BLOCK MINER")
        print("=" * 70)
        print(f"Network:        {self.network}")
        print(f"Difficulty:     0x{self.difficulty:08x}")
        print(f"Target:         {self.compact_to_target(self.bits)}")
        print(f"Timestamp:      {self.timestamp} ({datetime.fromtimestamp(self.timestamp)})")
        print(f"Message:        {self.message.decode()}")
        print(f"CPU Cores:      {num_processes}")
        print("=" * 70)
        print()

        print("⚠️  WARNING: This is a SIMPLIFIED miner for demonstration!")
        print("⚠️  For actual Phase 5 launch, use Bitcoin Core's CreateGenesisBlock()")
        print("⚠️  This script needs the correct merkle root from coinbase transaction")
        print()
        print("Starting mining... This may take hours or days depending on difficulty.")
        print("Press Ctrl+C to stop.")
        print()

        # Divide work among processes
        chunk_size = 0xFFFFFFFF // num_processes
        processes = []
        result_queue = multiprocessing.Queue()

        start_time = time.time()
        hashes_checked = 0

        try:
            # Start worker processes
            for i in range(num_processes):
                start_nonce = i * chunk_size
                end_nonce = (i + 1) * chunk_size if i < num_processes - 1 else 0xFFFFFFFF
                p = multiprocessing.Process(
                    target=self.mine_worker,
                    args=(start_nonce, end_nonce, result_queue)
                )
                p.start()
                processes.append(p)

            # Monitor results
            while True:
                msg_type, *data = result_queue.get()

                if msg_type == 'progress':
                    nonce, hash_result = data
                    hashes_checked += 100000
                    elapsed = time.time() - start_time
                    hashrate = hashes_checked / elapsed if elapsed > 0 else 0

                    print(f"Nonce: {nonce:10d} | "
                          f"Hash: {hash_result[:8].hex()}... | "
                          f"Rate: {hashrate/1000:.2f} KH/s | "
                          f"Time: {elapsed:.0f}s", end='\r')

                elif msg_type == 'found':
                    nonce, hash_result = data
                    print("\n")
                    print("=" * 70)
                    print("🎉 GENESIS BLOCK FOUND!")
                    print("=" * 70)
                    print(f"Nonce:          {nonce}")
                    print(f"Hash:           {hash_result[::-1].hex()}")
                    print(f"Time taken:     {time.time() - start_time:.2f} seconds")
                    print(f"Hashes checked: {hashes_checked:,}")
                    print()
                    print("Update patches/chainparams.cpp with:")
                    print(f"  Timestamp: {self.timestamp}")
                    print(f"  Nonce:     {nonce}")
                    print(f"  Bits:      0x{self.bits:08x}")
                    print("=" * 70)

                    # Terminate all processes
                    for p in processes:
                        p.terminate()
                    break

                elif msg_type == 'done':
                    # A process finished without finding
                    pass

        except KeyboardInterrupt:
            print("\n\nMining interrupted by user.")
            for p in processes:
                p.terminate()

        # Wait for all processes to finish
        for p in processes:
            p.join()


def main():
    parser = argparse.ArgumentParser(
        description='Mine JER Cryptocurrency genesis block with proper difficulty'
    )
    parser.add_argument(
        '--network',
        choices=['mainnet', 'testnet', 'regtest'],
        default='mainnet',
        help='Network to mine genesis for (default: mainnet)'
    )
    parser.add_argument(
        '--difficulty',
        type=lambda x: int(x, 16),
        default=0x1d00ffff,
        help='Difficulty in hex (default: 0x1d00ffff = Bitcoin start)'
    )
    parser.add_argument(
        '--processes',
        type=int,
        default=None,
        help='Number of CPU cores to use (default: all available)'
    )

    args = parser.parse_args()

    # Safety check
    if args.difficulty == 0x207fffff:
        print("⚠️  ERROR: You're using EASY difficulty (0x207fffff)")
        print("⚠️  This is for testing only, NOT for mainnet launch!")
        print("⚠️  Use --difficulty 0x1d00ffff for proper mainnet difficulty")
        print()
        response = input("Continue anyway? (yes/no): ")
        if response.lower() != 'yes':
            print("Aborted.")
            return

    miner = GenesisBlockMiner(network=args.network, difficulty=args.difficulty)
    miner.mine(num_processes=args.processes)


if __name__ == '__main__':
    main()
