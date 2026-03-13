# Remixx — Solidity Smart Contract Collection

A collection of Solidity smart contracts covering common DeFi and NFT patterns, including auctions, marketplaces, swaps, staking, and security vulnerability examples.

## Overview

This repository serves as a learning and reference collection of various Solidity contract patterns built and tested using Remix IDE.

## Contracts

| Contract | Description |
|----------|-------------|
| `NftMarketplace.sol` | Full NFT marketplace with listing, buying, and selling functionality |
| `Aunction.sol` | Mystery box auction with authorized bidders and prize pools |
| `Swap.sol` | Basic ERC20 token swap contract |
| `StakeTest.sol` | Token staking implementation |
| `Audit.sol` | Auction contract for security audit practice |
| `BuyAndSell.sol` | Buy and sell mechanism |
| `DelegateCalll.sol` | Delegatecall pattern examples |
| `MultiDelegateCall.sol` | Multi-delegatecall implementation |
| `DelegatecallVulnerability.sol` | Delegatecall security vulnerability demo |
| `RiskyDelegatecall.sol` | Risky delegatecall patterns |
| `VulnerableStateVariableContract.sol` | State variable vulnerability example |
| `VulnerableStorageContract.sol` | Storage vulnerability example |

## Tech Stack

- **Solidity** ^0.8.x
- **Remix IDE** for development and deployment
- **OpenZeppelin** (Counters, ReentrancyGuard, ERC20, ERC721)

## Topics Covered

- NFT Marketplaces
- Auction mechanisms
- Token swaps
- Staking contracts
- Delegatecall patterns and vulnerabilities
- Storage layout vulnerabilities
- Smart contract security patterns

## Getting Started

These contracts can be loaded directly in [Remix IDE](https://remix.ethereum.org/):

1. Copy any `.sol` file into Remix
2. Compile with Solidity ^0.8.x
3. Deploy to a local VM or testnet

## License

MIT
