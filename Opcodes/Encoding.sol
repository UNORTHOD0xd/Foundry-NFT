// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract Encoding {
    function combineStrings() public pure returns (string memory) {
        return string(abi.encodePacked("Hello, ", "world!"));   
    } 

    // When we send a transaction, it is compiled down to bytecode and sent in a data object
    // That data object now governs how future transactions to that address will behave
    // Opcodes are the low-level instructions that the EVM understands
    // Each opcode has a corresponding bytecode representation
    // The EVM executes these opcodes sequentially to perform operations
    // Opcodes are stack-based, meaning they operate on a last-in-first-out (LIFO) stack structure
    // Any computer able to execute these opcodes can run the same smart contract and is considered EVM-compatible


    
    function encodeNumber() public pure returns (bytes memory) {
        bytes memory number = abi.encode(uint8(1));
        return number; // 0x01
    }

    // abi.encodePacked is a low-level function that concatenates and encodes the input arguments into a single bytes array
    // It is more gas efficient than abi.encode because it does not include padding or length information

    function encodeString() public pure returns (bytes memory) {
        bytes memory str = abi.encodePacked("Hello");
        return str; // 0x48656c6c6f
    } // when we encode a string, it is converted to its ASCII representation

    function decodeString() public pure returns (string memory) {
        string memory SomeString = abi.decode(encodeString(), (string));
        return SomeString; // "Hello"
    } // we can decode the encoded string back to its original form using abi.decode

    // We can do cool stuff like sending transactions with raw bytecode
    // This is advanced and not typically done in everyday smart contract development

    // In order to do this we need a few things:
    // 1. The ABI
    // 2. The Contract Address
    // 3. The Function Signature
    // 4. The Parameters (if any)

    // Solidity has some "low-level" functions that allow us to interact with contracts using raw bytecode
    // These functions are:
    // 1. call: allows us to call a function on a contract
    // 2. delegatecall: similar to call, but retains the context of the caller
    // 3. staticcall: allows us to call a function without modifying state (used for view and pure functions)
    // 4. send: used to send Ether to a contract
    // 5. transfer: similar to send, but automatically reverts on failure

    // We used the call functon in previous project to give the winner their prize money
    function withdraw(address recentWinner) public {
        (bool success, ) = recentWinner.call{value: address(this).balance}(""); 
        require(success, "Transfer failed");    
    }

    // Remember this!
    //  1. In our {} we are able to pass specific fields such as value, gas, etc.
    //  2. In our () we are able to pass the function signature and parameters (if any)
    // If we want  to call a function, or send any data we'd need to put that in the () part
}