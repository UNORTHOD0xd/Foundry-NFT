// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {BasicNft} from "../src/BasicNft.sol";
import {DeployBasicNft} from "../script/DeployBasicNft.s.sol";

contract BasicNftTest is Test {
    DeployBasicNft public deployer;
    BasicNft public basicNft;
    address public USER = makeAddr("user");
    string public constant PUG = "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";


    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testNameIsCorrect() public view {
        assert(keccak256(bytes(basicNft.name())) == keccak256(bytes("Doggie"))); // Check if the name is "Doggie" by comparing keccak256 hashes of the strings 
    }

    function testCanMintAndHaveABalance() public {
        vm.prank(USER); // Simulate the next call as coming from USER
        basicNft.mintNft(PUG); // USER mints an NFT with the PUG URI
        
        assert(basicNft.balanceOf(USER) == 1); // Check if USER's balance is now 1
    }

    function testTokenURIIsCorrect() public {
        vm.prank(USER); // Simulate the next call as coming from USER
        basicNft.mintNft(PUG); // USER mints an NFT with the PUG URI

        assert(keccak256(abi.encodePacked(basicNft.tokenURI(0))) == keccak256(abi.encodePacked(PUG))); // Check if the token URI of token ID 0 matches the PUG URI
    }

}