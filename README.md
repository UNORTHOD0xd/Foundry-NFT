# NFT & Dynamic NFT Smart Contract Project

A comprehensive exploration of NFT (Non-Fungible Token) development on Ethereum, built with Foundry. This project is part of the **Cyfrin Updraft** curriculum and covers both basic NFT implementation and advanced dynamic NFT concepts.

## Table of Contents
- [Overview](#overview)
- [Project Structure](#project-structure)
- [Key Concepts Learned](#key-concepts-learned)
- [Smart Contracts](#smart-contracts)
- [Getting Started](#getting-started)
- [Testing](#testing)
- [Deployment](#deployment)
- [Technologies Used](#technologies-used)

## Overview

This project demonstrates the creation and deployment of two types of NFTs:

1. **BasicNft**: A standard ERC-721 NFT with IPFS-hosted metadata
2. **MoodNft**: A dynamic NFT with on-chain SVG storage that changes based on user interaction

## Project Structure

```
Foundry-NFT/
├── src/
│   ├── BasicNft.sol          # Standard NFT implementation
│   └── MoodNft.sol            # Dynamic NFT with on-chain SVG
├── script/
│   ├── DeployBasicNft.s.sol   # Basic NFT deployment script
│   ├── DeployMoodNft.s.sol    # Dynamic NFT deployment script
│   └── Interactions.s.sol     # Interaction scripts for minting/flipping
├── test/
│   ├── BasicNftTest.t.sol     # Basic NFT tests
│   ├── MoodNftTest.t.sol      # Dynamic NFT tests (100% coverage)
│   └── DeployMoodNftTest.t.sol
└── img/
    └── DynamicNFT/
        ├── happy.svg          # Happy mood SVG image
        └── sad.svg            # Sad mood SVG image
```

## Key Concepts Learned

### 1. ERC-721 Standard
- Understanding the OpenZeppelin ERC-721 implementation
- Core functions: `_safeMint()`, `ownerOf()`, `balanceOf()`
- Token counter pattern for unique token IDs
- Override functionality for custom token metadata

### 2. NFT Metadata & Token URIs
- **IPFS Integration**: Storing metadata off-chain using IPFS
- **Token URI Structure**: Linking token IDs to metadata locations
- Understanding the `tokenURI()` function and its role in NFT standards

### 3. On-Chain SVG Storage
- Encoding SVG images directly on the blockchain
- **Base64 Encoding**: Converting SVG to Base64 for on-chain storage
- Reducing dependency on external storage solutions
- Creating fully on-chain NFTs that never lose their images

### 4. Dynamic NFTs
- NFTs that can change state over time or based on conditions
- State management using enums (`Mood.SAD`, `Mood.HAPPY`)
- Conditional rendering based on current state
- **MoodNft** demonstrates a mood-flipping mechanism where:
  - Users mint NFTs that start in a HAPPY mood
  - Owners can flip between HAPPY and SAD states
  - The displayed image changes dynamically based on current mood

### 5. Access Control & Authorization
- Owner-only functionality using `_checkAuthorized()`
- Approval mechanisms (`approve()`, `setApprovalForAll()`)
- Ensuring only token owners or approved addresses can modify state
- Security best practices for state-changing functions

### 6. Data URI Scheme
- Creating data URIs for embedded content
- JSON metadata structure:
  ```json
  {
    "name": "Mood Nft",
    "description": "An NFT that changes based on mood",
    "attributes": [{"trait_type": "moodiness", "value": 100}],
    "image": "data:image/svg+xml;base64,..."
  }
  ```
- Base64 encoding of JSON metadata for on-chain storage

### 7. Smart Contract Testing with Foundry
- Comprehensive test coverage (100% on MoodNft)
- Testing ownership and authorization
- State change verification
- Multiple user simulation
- Edge case handling (non-existent tokens, unauthorized access)

### 8. Deployment Strategies
- Using Foundry scripts for repeatable deployments
- Reading external files (SVG images) during deployment
- Converting assets to blockchain-compatible formats
- Deploying to testnets for validation

### 9. Gas Optimization Considerations
- Trade-offs between on-chain and off-chain storage
- BasicNft uses minimal on-chain storage (just a URI pointer)
- MoodNft stores everything on-chain at a higher gas cost
- Understanding when each approach is appropriate

### 10. Foundry Development Tools
- **Forge**: Testing framework with advanced cheatcodes
- **vm.prank()**: Simulating calls from different addresses
- **vm.expectRevert()**: Testing failure cases
- **vm.readFile()**: Reading external files during deployment
- Automated testing with `forge test`

## Smart Contracts

### BasicNft.sol
A standard ERC-721 implementation with:
- Token counter for sequential minting
- Mapping of token IDs to IPFS URIs
- Custom `tokenURI()` override
- Simple `mintNft()` function accepting a URI parameter

**Key Learning**: Basic NFT structure with off-chain metadata storage.

### MoodNft.sol
An advanced dynamic NFT featuring:
- Enum-based mood system (SAD/HAPPY)
- On-chain SVG image storage (Base64-encoded)
- `flipMood()` function for state changes
- Dynamic `tokenURI()` that returns different metadata based on mood
- Authorization checks ensuring only owners can change mood
- Fully on-chain metadata generation

**Key Learning**: Dynamic NFTs with state management and on-chain SVG rendering.

## Getting Started

### Prerequisites
- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- Git

### Installation

```bash
# Clone the repository
git clone <your-repo-url>
cd Foundry-NFT

# Install dependencies
forge install

# Build the project
forge build
```

## Testing

Run the comprehensive test suite:

```bash
# Run all tests
forge test

# Run tests with verbosity
forge test -vvv

# Run specific test file
forge test --match-path test/MoodNftTest.t.sol

# Check test coverage
forge coverage
```

The project includes extensive tests covering:
- Minting functionality
- Ownership verification
- Mood flipping mechanics
- Authorization and access control
- Edge cases and error handling

## Deployment

### Deploy BasicNft

```bash
forge script script/DeployBasicNft.s.sol:DeployBasicNft --rpc-url <RPC_URL> --private-key <PRIVATE_KEY> --broadcast
```

### Deploy MoodNft

```bash
forge script script/DeployMoodNft.s.sol:DeployMoodNft --rpc-url <RPC_URL> --private-key <PRIVATE_KEY> --broadcast
```

### Interact with Contracts

Use the interaction scripts to mint and flip moods:

```bash
# Mint a MoodNft
forge script script/Interactions.s.sol:MintMoodNft --rpc-url <RPC_URL> --private-key <PRIVATE_KEY> --broadcast

# Flip the mood
forge script script/Interactions.s.sol:FlipMoodNft --rpc-url <RPC_URL> --private-key <PRIVATE_KEY> --broadcast
```

## Technologies Used

- **Solidity ^0.8.18**: Smart contract programming language
- **Foundry**: Ethereum development framework
  - Forge: Testing framework
  - Cast: CLI for interacting with contracts
  - Anvil: Local Ethereum node
- **OpenZeppelin Contracts**: Audited ERC-721 implementation
- **IPFS**: Decentralized storage for BasicNft metadata
- **Base64 Encoding**: For on-chain SVG storage in MoodNft

## Key Takeaways

1. **NFTs are more than just images**: They're programmable tokens with rich metadata
2. **Storage trade-offs**: Off-chain (IPFS) vs on-chain storage each have benefits
3. **Dynamic NFTs enable new use cases**: State-changing NFTs open up gaming, identity, and interactive art possibilities
4. **Security matters**: Proper authorization checks are critical for state-changing functions
5. **Testing is essential**: Comprehensive tests ensure contract behavior is correct and secure
6. **Foundry is powerful**: Modern tooling makes Solidity development efficient and reliable

## Resources

- [Cyfrin Updraft](https://updraft.cyfrin.io/)
- [OpenZeppelin ERC-721 Documentation](https://docs.openzeppelin.com/contracts/4.x/erc721)
- [Foundry Book](https://book.getfoundry.sh/)
- [IPFS Documentation](https://docs.ipfs.tech/)

## License

MIT

---

