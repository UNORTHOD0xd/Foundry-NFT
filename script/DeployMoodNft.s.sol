// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MoodNft} from "../src/MoodNft.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract DeployMoodNft is Script {
    function run() external returns (MoodNft) {

    }

    function svgToImageUri(string memory svg) public pure returns (string memory) {
        // Prefix for Base64-encoded SVG image URI
        string memory baseUrl = "data:image/svg+xml;base64,";
        // Encode the SVG image to Base64
        string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(svg))));
        // Concatenate the prefix and the Base64-encoded SVG image
        return string(abi.encodePacked(baseUrl, svgBase64Encoded));
    }
}