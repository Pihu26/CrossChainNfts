# 🌉 Cross-Chain NFT Transfer with Chainlink CCIP and Foundry  

## Introduction  
This project demonstrates the seamless transfer of NFTs across blockchain networks using **Chainlink CCIP (Cross-Chain Interoperability Protocol)** and **Foundry**. It bridges the gap between **Ethereum Sepolia** and **Polygon Mumbai**, allowing NFTs from an ERC721 collection to be securely transferred between these chains.  

The ability to transfer NFTs across chains enhances interoperability and opens up new possibilities in the NFT space. This project shows how we can leverage **Chainlink CCIP** and **Foundry** to make cross-chain transfers seamless and secure.

## Features  
- **Cross-Chain NFT Transfers**: Transfer unique ERC721 tokens between Ethereum and Polygon networks.  
- **Secure and Reliable**: Powered by Chainlink CCIP for trustless communication.  
- **Interoperability**: Showcasing the true potential of Web3 by enabling NFTs to move across different ecosystems.  
- **Foundry Usage**: Developed and tested smart contracts using Foundry for efficient and fast testing.  

## How It Works  
1. **NFT Ownership Verification**: Ensures that only the rightful owner of the NFT can initiate the transfer.  
2. **Cross-Chain Messaging**: Uses **Chainlink CCIP** to send the NFT metadata and transfer request between chains.  
3. **Mint and Burn Mechanism**: The NFT is burned on the source chain and minted on the destination chain to ensure a single instance exists.  
4. **Destination Contract Interaction**: The target chain contract receives and maps the NFT to a new token on that chain.

## Tech Stack  
- **Blockchain Networks**: Ethereum Sepolia, Polygon Mumbai  
- **Smart Contracts**: ERC721 (NFT standard), Solidity  
- **Interoperability**: Chainlink CCIP (Cross-Chain Interoperability Protocol)  
- **Development Tools**: **Foundry** (for smart contract testing and development)
- **Payment**: MetaMask (for interacting with the dApp)  

## Prerequisites  
To run this project locally, ensure you have the following installed:  
- [Node.js](https://nodejs.org/) (v16 or higher)  
- [Foundry](https://book.getfoundry.sh/) (for efficient contract development and testing)  



