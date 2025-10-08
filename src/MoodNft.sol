// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {
    uint256 private s_tokenCounter;
    string private s_sadSvgImageUri; // Base64-encoded SVG image URI for the "sad" mood
    string private s_happySvgImageUri; // Base64-encoded SVG image URI for the "happy" mood

    enum Mood {
        SAD,
        HAPPY
    }

    mapping(uint256 => Mood) private s_tokenIdToMood; // Mapping from token ID to its current mood

    constructor(
        string memory sadSvgImageUri, 
        string memory happySvgImageUri
    ) ERC721("MoodNft", "MN") {
        s_tokenCounter = 0;
        s_sadSvgImageUri = sadSvgImageUri;
        s_happySvgImageUri = happySvgImageUri;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY; // New NFTs start with the "happy" mood
        s_tokenCounter++;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 tokenId)
    public view override returns (string memory) {
        _requireOwned(tokenId); // Ensure the token exists before returning its URI
        string memory imageUri;
        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            imageUri = s_happySvgImageUri;
        } else {
            imageUri = s_sadSvgImageUri;        
        }

        return string(
            abi.encodePacked(
                    _baseURI(), 
                Base64.encode(
                    bytes (
                        abi.encodePacked(
                            '{"name": "Mood Nft", ',
                            '"description": "An NFT that changes based on mood", ',
                            '"attributes": [{"trait_type": "moodiness", "value": 100}], ',
                            '"image": "',
                            imageUri,
                            '"}'
                        ) // Encode the JSON metadata for the NFT
                    ) // Create the JSON metadata for the NFT
                ) // Encode the JSON metadata in Base64
            ) // Concatenate the base URI with the encoded metadata
        ); // Return the Base64-encoded JSON metadata
    }
                
            
        
        
}