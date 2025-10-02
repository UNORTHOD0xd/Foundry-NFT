// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BasicNft is ERC721 {
    uint256 private s_tokenCounter; 

    constructor() ERC721("Doggie", "DOG") {
        s_tokenCounter = 0; // Initialize token counter when contract is deployed
    }

    function mintNft() public returns (uint256) {
        s_tokenCounter += 1; // Increment token counter
        _safeMint(msg.sender, s_tokenCounter); // Mint the NFT to the caller's address
        return s_tokenCounter; // Return the new token ID
    }

    function tokenURI (uint256 tokenId) public view override returns (string memory) {
        
    }
}