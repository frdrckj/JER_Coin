// Temporary genesis mining code for Bitcoin Core
// Insert this into chainparams.cpp after genesis = CreateGenesisBlock(...)

// Mining loop to find valid genesis block
std::cout << "Mining mainnet genesis block with difficulty 0x1d00ffff..." << std::endl;
std::cout << "This will take 2-48 hours on M-series Mac..." << std::endl;
std::cout << "Timestamp: " << 1761721935 << std::endl;
std::cout << "Target: " << consensus.powLimit.ToString() << std::endl;

uint256 target;
target.SetCompact(0x1d00ffff);

uint32_t start_time = time(nullptr);
uint32_t last_update = start_time;
uint64_t hashes = 0;

for (uint32_t nNonce = 0; nNonce < 0xffffffff; nNonce++) {
    genesis.nNonce = nNonce;
    uint256 hash = genesis.GetHash();
    hashes++;

    if (hash <= target) {
        std::cout << "\n=== GENESIS BLOCK FOUND! ===" << std::endl;
        std::cout << "Block Hash:  " << hash.ToString() << std::endl;
        std::cout << "Merkle Root: " << genesis.hashMerkleRoot.ToString() << std::endl;
        std::cout << "Nonce:       " << nNonce << std::endl;
        std::cout << "Timestamp:   " << genesis.nTime << std::endl;
        std::cout << "Mining time: " << (time(nullptr) - start_time) << " seconds" << std::endl;
        std::cout << "Total hashes: " << hashes << std::endl;
        break;
    }

    // Progress update every 10 seconds
    if (time(nullptr) - last_update >= 10) {
        uint32_t elapsed = time(nullptr) - start_time;
        double hashrate = elapsed > 0 ? (double)hashes / elapsed : 0;
        std::cout << "Nonce: " << nNonce
                  << " | Time: " << elapsed << "s"
                  << " | Rate: " << (hashrate/1000) << " KH/s"
                  << " | Progress: " << (nNonce * 100.0 / 0xffffffff) << "%"
                  << std::endl;
        last_update = time(nullptr);
    }
}
