// Standalone Genesis Block Miner for Jer Cryptocurrency
// Compile: g++ -std=c++17 -O3 -o mine-genesis mine-genesis-standalone.cpp -lcrypto
// Run: ./mine-genesis

#include <iostream>
#include <iomanip>
#include <sstream>
#include <cstring>
#include <ctime>
#include <openssl/sha.h>

// Bitcoin's double SHA256
void double_sha256(const unsigned char* data, size_t len, unsigned char* hash) {
    unsigned char temp[32];
    SHA256(data, len, temp);
    SHA256(temp, 32, hash);
}

// Convert hash to hex string
std::string hash_to_hex(const unsigned char* hash) {
    std::stringstream ss;
    for (int i = 31; i >= 0; i--) {
        ss << std::hex << std::setw(2) << std::setfill('0') << (int)hash[i];
    }
    return ss.str();
}

// Check if hash meets target
bool check_target(const unsigned char* hash) {
    // Target for 0x1d00ffff: 00000000ffff0000000000000000000000000000000000000000000000000000
    // First 4 bytes must be 0x00000000
    if (hash[31] != 0x00 || hash[30] != 0x00 || hash[29] != 0x00 || hash[28] != 0x00) {
        return false;
    }
    // Next 2 bytes must be <= 0xffff
    if (hash[27] > 0xff) return false;
    if (hash[27] == 0xff && hash[26] > 0xff) return false;
    return true;
}

// Simplified block header structure
struct BlockHeader {
    uint32_t version;
    unsigned char prev_block[32];
    unsigned char merkle_root[32];
    uint32_t timestamp;
    uint32_t bits;
    uint32_t nonce;

    void serialize(unsigned char* output) const {
        memcpy(output, &version, 4);
        memcpy(output + 4, prev_block, 32);
        memcpy(output + 36, merkle_root, 32);
        memcpy(output + 68, &timestamp, 4);
        memcpy(output + 72, &bits, 4);
        memcpy(output + 76, &nonce, 4);
    }
};

int main() {
    std::cout << "======================================================================\n";
    std::cout << "JER CRYPTOCURRENCY - GENESIS BLOCK MINER\n";
    std::cout << "======================================================================\n\n";

    // Jer mainnet genesis parameters
    BlockHeader header;
    header.version = 1;
    memset(header.prev_block, 0, 32);

    // Merkle root from chainparams.cpp: 25da88c5d4c2f2a89148f6bfe33862805bea3edb7712ae9babf5709aa1f99658
    unsigned char merkle_hex[] = {
        0x58, 0x96, 0xf9, 0xa1, 0x9a, 0x70, 0xf5, 0xab, 0x9b, 0xae, 0x12, 0x77, 0xdb, 0x3e, 0xea, 0x5b,
        0x80, 0x62, 0x38, 0xe3, 0xbf, 0xf6, 0x48, 0x91, 0xa8, 0xf2, 0xc2, 0xd4, 0xc5, 0x88, 0xda, 0x25
    };
    memcpy(header.merkle_root, merkle_hex, 32);

    header.timestamp = 1761721935;  // From chainparams.cpp
    header.bits = 0x1d00ffff;
    header.nonce = 0;

    std::cout << "Mining Configuration:\n";
    std::cout << "  Timestamp:   " << header.timestamp << "\n";
    std::cout << "  Difficulty:  0x" << std::hex << header.bits << std::dec << "\n";
    std::cout << "  Target:      00000000ffff0000000000000000000000000000000000000000000000000000\n";
    std::cout << "  Merkle Root: 25da88c5d4c2f2a89148f6bfe33862805bea3edb7712ae9babf5709aa1f99658\n\n";
    std::cout << "Mining will try multiple timestamps if needed...\n\n";

    uint32_t base_timestamp = header.timestamp;
    uint32_t start_time = time(nullptr);
    uint64_t total_hashes = 0;

    // Try different timestamps if nonce space exhausted
    for (int timestamp_offset = 0; timestamp_offset < 100; timestamp_offset++) {
        header.timestamp = base_timestamp + timestamp_offset;

        if (timestamp_offset > 0) {
            std::cout << "\nNonce space exhausted. Trying timestamp: " << header.timestamp << "\n";
        }

        unsigned char block_data[80];
        unsigned char hash[32];
        uint32_t last_update = time(nullptr);

        // Try all possible nonces for this timestamp
        for (uint64_t nonce = 0; nonce <= 0xffffffffULL; nonce++) {
            header.nonce = (uint32_t)nonce;
            header.serialize(block_data);
            double_sha256(block_data, 80, hash);
            total_hashes++;

            if (check_target(hash)) {
                uint32_t elapsed = time(nullptr) - start_time;

                std::cout << "\n\n";
                std::cout << "======================================================================\n";
                std::cout << "🎉 GENESIS BLOCK FOUND!\n";
                std::cout << "======================================================================\n\n";
                std::cout << "Block Hash:  " << hash_to_hex(hash) << "\n";
                std::cout << "Merkle Root: 25da88c5d4c2f2a89148f6bfe33862805bea3edb7712ae9babf5709aa1f99658\n";
                std::cout << "Timestamp:   " << header.timestamp << "\n";
                std::cout << "Nonce:       " << header.nonce << "\n";
                std::cout << "Bits:        0x" << std::hex << header.bits << std::dec << "\n\n";
                std::cout << "Mining Stats:\n";
                std::cout << "  Total time:   " << elapsed << " seconds (" << elapsed/60.0 << " minutes)\n";
                std::cout << "  Total hashes: " << total_hashes << "\n";
                std::cout << "  Hash rate:    " << (elapsed > 0 ? total_hashes/elapsed/1000.0 : 0) << " KH/s\n\n";
                std::cout << "======================================================================\n\n";

                std::cout << "Update patches/chainparams.cpp with:\n\n";
                std::cout << "genesis = CreateGenesisBlock(pszTimestamp_main, genesisOutputScript_main,\n";
                std::cout << "    " << header.timestamp << ", " << header.nonce << ", 0x" << std::hex << header.bits << std::dec << ", 1, 50 * COIN);\n";
                std::cout << "consensus.hashGenesisBlock = genesis.GetHash();\n";
                std::cout << "assert(consensus.hashGenesisBlock == uint256{\"" << hash_to_hex(hash) << "\"});\n\n";

                return 0;
            }

            // Progress update every 10 seconds
            if (time(nullptr) - last_update >= 10) {
                uint32_t elapsed = time(nullptr) - start_time;
                double hashrate = elapsed > 0 ? (double)total_hashes / elapsed : 0;
                std::cout << "Nonce: " << std::setw(10) << nonce
                         << " | Time: " << std::setw(6) << elapsed << "s"
                         << " | Rate: " << std::fixed << std::setprecision(1) << std::setw(8) << (hashrate/1000) << " KH/s"
                         << " | Progress: " << std::fixed << std::setprecision(3) << (nonce * 100.0 / 0xffffffffULL) << "%"
                         << "\r" << std::flush;
                last_update = time(nullptr);
            }
        }
    }

    std::cout << "\n\n❌ No valid genesis block found after trying 100 timestamps.\n";
    std::cout << "This is extremely unlikely. Please check the target difficulty.\n";

    return 1;
}
