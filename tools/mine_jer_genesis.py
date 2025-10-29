#!/usr/bin/env python3
"""
JER Testnet Genesis Block Miner
Uses Bitcoin's actual block format to mine proper genesis
"""

import hashlib
import struct
import time
import multiprocessing as mp
from datetime import datetime

# From chainparams.cpp testnet section
TIMESTAMP = 1761633769
MERKLE_ROOT = bytes.fromhex("2c888fa0d0128539937a664934e0d143cb8d6b34ae916656239ebec067ebaeb9")[::-1]
DIFFICULTY_BITS = 0x1d00ffff
VERSION = 1

def compact_to_target(bits):
    """Convert compact difficulty to target"""
    exponent = bits >> 24
    mantissa = bits & 0xffffff
    if mantissa & 0x800000:
        mantissa >>= 8
        exponent -= 1
    target = mantissa
    if exponent > 3:
        target <<= (8 * (exponent - 3))
    elif exponent < 3:
        target >>= (8 * (3 - exponent))
    return target

def hash_block(version, prev_block, merkle_root, timestamp, bits, nonce):
    """Hash a block header"""
    header = struct.pack('<I', version)
    header += prev_block
    header += merkle_root
    header += struct.pack('<I', timestamp)
    header += struct.pack('<I', bits)
    header += struct.pack('<I', nonce)

    # Double SHA-256
    hash1 = hashlib.sha256(header).digest()
    hash2 = hashlib.sha256(hash1).digest()
    return hash2

def check_hash(hash_bytes, target):
    """Check if hash meets difficulty target"""
    hash_int = int.from_bytes(hash_bytes, byteorder='little')
    return hash_int < target

def mine_worker(start_nonce, end_nonce, result_queue, stop_event):
    """Worker process for parallel mining"""
    prev_block = b'\x00' * 32
    target = compact_to_target(DIFFICULTY_BITS)

    for nonce in range(start_nonce, end_nonce):
        if stop_event.is_set():
            return

        if nonce % 100000 == 0:
            hash_result = hash_block(VERSION, prev_block, MERKLE_ROOT, TIMESTAMP, DIFFICULTY_BITS, nonce)
            result_queue.put(('progress', nonce, hash_result))

        hash_result = hash_block(VERSION, prev_block, MERKLE_ROOT, TIMESTAMP, DIFFICULTY_BITS, nonce)

        if check_hash(hash_result, target):
            result_queue.put(('found', nonce, hash_result))
            stop_event.set()
            return

    result_queue.put(('done', start_nonce))

def main():
    num_processes = mp.cpu_count()
    target = compact_to_target(DIFFICULTY_BITS)

    print("=" * 70)
    print("JER TESTNET GENESIS BLOCK MINER")
    print("=" * 70)
    print(f"Timestamp:      {TIMESTAMP} ({datetime.fromtimestamp(TIMESTAMP)})")
    print(f"Merkle Root:    {MERKLE_ROOT[::-1].hex()}")
    print(f"Difficulty:     0x{DIFFICULTY_BITS:08x}")
    print(f"Target:         {target:064x}")
    print(f"CPU Cores:      {num_processes}")
    print("=" * 70)
    print()
    print("Mining... This may take 2-48 hours on M-series Mac")
    print("Press Ctrl+C to stop")
    print()

    chunk_size = 0xFFFFFFFF // num_processes
    processes = []
    result_queue = mp.Queue()
    stop_event = mp.Event()

    start_time = time.time()
    hashes_checked = 0

    try:
        # Start worker processes
        for i in range(num_processes):
            start_nonce = i * chunk_size
            end_nonce = (i + 1) * chunk_size if i < num_processes - 1 else 0xFFFFFFFF
            p = mp.Process(target=mine_worker, args=(start_nonce, end_nonce, result_queue, stop_event))
            p.start()
            processes.append(p)

        # Monitor results
        while True:
            if stop_event.is_set() and result_queue.empty():
                break

            try:
                msg = result_queue.get(timeout=1)
            except:
                continue

            msg_type = msg[0]

            if msg_type == 'progress':
                _, nonce, hash_result = msg
                hashes_checked += 100000
                elapsed = time.time() - start_time
                hashrate = hashes_checked / elapsed if elapsed > 0 else 0

                print(f"Nonce: {nonce:10d} | "
                      f"Hash: {hash_result[:8].hex()}... | "
                      f"Rate: {hashrate/1000:.2f} KH/s | "
                      f"Time: {int(elapsed)}s", end='\r', flush=True)

            elif msg_type == 'found':
                _, nonce, hash_result = msg
                elapsed = time.time() - start_time

                print("\n")
                print("=" * 70)
                print("🎉 GENESIS BLOCK FOUND!")
                print("=" * 70)
                print(f"Nonce:          {nonce}")
                print(f"Hash:           {hash_result[::-1].hex()}")
                print(f"Time:           {elapsed:.2f} seconds ({elapsed/3600:.2f} hours)")
                print(f"Hashes:         {hashes_checked:,}")
                print()
                print("Update patches/chainparams.cpp line 266:")
                print(f"  genesis = CreateGenesisBlock(..., {TIMESTAMP}, {nonce}, 0x{DIFFICULTY_BITS:08x}, 1, 50 * COIN);")
                print()
                print("Update line 271:")
                print(f'  assert(consensus.hashGenesisBlock == uint256{{"{hash_result[::-1].hex()}"}});')
                print("=" * 70)

                stop_event.set()
                break

    except KeyboardInterrupt:
        print("\n\nMining interrupted by user")
        stop_event.set()

    finally:
        # Wait for all processes
        for p in processes:
            p.join(timeout=1)
            if p.is_alive():
                p.terminate()

if __name__ == '__main__':
    main()
