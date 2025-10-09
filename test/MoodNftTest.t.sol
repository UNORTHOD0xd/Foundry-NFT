// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {MoodNft} from "../src/MoodNft.sol";
import {DeployMoodNft} from "../script/DeployMoodNft.s.sol";

contract MoodNftTest is Test {
    MoodNft moodNft;
    DeployMoodNft deployer;
    

    address USER = makeAddr("user");
    address USER2 = makeAddr("user2");

    function setUp() public {
        deployer = new DeployMoodNft();
        moodNft = deployer.run();
    }


    function testMintNftStartsWithHappyMood() public {
        vm.prank(USER);
        moodNft.mintNft();

        // Token URI should contain the happy SVG
        string memory tokenUri = moodNft.tokenURI(0);
        assertGt(bytes(tokenUri).length, 0);
    }

    function testMintIncrementsTokenCounter() public {
        vm.prank(USER);
        moodNft.mintNft();

        vm.prank(USER2);
        moodNft.mintNft();

        // Verify USER owns token 0
        assertEq(moodNft.ownerOf(0), USER);
        // Verify USER2 owns token 1
        assertEq(moodNft.ownerOf(1), USER2);
    }

    function testMintMultipleNfts() public {
        vm.startPrank(USER);
        moodNft.mintNft();
        moodNft.mintNft();
        moodNft.mintNft();
        vm.stopPrank();

        assertEq(moodNft.balanceOf(USER), 3);
        assertEq(moodNft.ownerOf(0), USER);
        assertEq(moodNft.ownerOf(1), USER);
        assertEq(moodNft.ownerOf(2), USER);
    }

    function testOwnerCanFlipMoodFromHappyToSad() public {
        vm.startPrank(USER);
        moodNft.mintNft();

        // Get initial URI (should be happy)
        string memory happyUri = moodNft.tokenURI(0);

        // Flip mood
        moodNft.flipMood(0);

        // Get new URI (should be sad)
        string memory sadUri = moodNft.tokenURI(0);

        // URIs should be different
        assertFalse(
            keccak256(abi.encodePacked(happyUri)) == keccak256(abi.encodePacked(sadUri)),
            "Token URI should change after mood flip"
        );
        vm.stopPrank();
    }

    function testOwnerCanFlipMoodFromSadToHappy() public {
        vm.startPrank(USER);
        moodNft.mintNft();

        // Flip to sad
        moodNft.flipMood(0);
        string memory sadUri = moodNft.tokenURI(0);

        // Flip back to happy
        moodNft.flipMood(0);
        string memory happyUri = moodNft.tokenURI(0);

        // URIs should be different
        assertFalse(
            keccak256(abi.encodePacked(happyUri)) == keccak256(abi.encodePacked(sadUri)),
            "Token URI should change after mood flip"
        );
        vm.stopPrank();
    }

    function testFlipMoodMultipleTimes() public {
        vm.startPrank(USER);
        moodNft.mintNft();

        string memory uri1 = moodNft.tokenURI(0);

        moodNft.flipMood(0);
        string memory uri2 = moodNft.tokenURI(0);

        moodNft.flipMood(0);
        string memory uri3 = moodNft.tokenURI(0);

        // After even number of flips, should be back to original
        assertEq(
            keccak256(abi.encodePacked(uri1)),
            keccak256(abi.encodePacked(uri3)),
            "After even flips, should return to original mood"
        );

        // After odd number of flips, should be different
        assertFalse(
            keccak256(abi.encodePacked(uri1)) == keccak256(abi.encodePacked(uri2)),
            "After odd flips, should be different mood"
        );
        vm.stopPrank();
    }


    function testNonOwnerCannotFlipMood() public {
        vm.prank(USER);
        moodNft.mintNft();

        // Try to flip mood as non-owner
        vm.prank(USER2);
        vm.expectRevert();
        moodNft.flipMood(0);
    }

    function testApprovedAddressCanFlipMood() public {
        vm.prank(USER);
        moodNft.mintNft();

        // Approve USER2
        vm.prank(USER);
        moodNft.approve(USER2, 0);

        // USER2 should be able to flip mood
        vm.prank(USER2);
        moodNft.flipMood(0);
    }

    function testOperatorCanFlipMood() public {
        vm.prank(USER);
        moodNft.mintNft();

        // Set USER2 as operator
        vm.prank(USER);
        moodNft.setApprovalForAll(USER2, true);

        // USER2 should be able to flip mood
        vm.prank(USER2);
        moodNft.flipMood(0);
    }

    function testCannotFlipMoodOfNonExistentToken() public {
        vm.prank(USER);
        vm.expectRevert();
        moodNft.flipMood(999);
    }


    function testTokenURIRevertsForNonExistentToken() public {
        vm.expectRevert();
        moodNft.tokenURI(0);
    }

}