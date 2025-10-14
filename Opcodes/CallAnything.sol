// SPDX-License-Identifier: MIT

// In order to call a function using only the data field of a transaction, we need to encode:
// The function name and parameter types (function signature)

//Each contract assigns a unique identifier to each function called a function selector

// The function selector is the first 4 bytes of the Keccak-256 hash of the function signature
// Example: function signature"transfer(address,uint256)" -> function selector: 0xa9059cbb

pragma solidity ^0.8.7;

contract CallAnything {
    address public s_someAddress;
    uint256 public s_amount;

    function transfer(address someAddress, uint256 amount) public {
        s_someAddress = someAddress;
        s_amount = amount;
    }

    function getselectorOne() public pure returns (bytes4 selector) {
        selector = bytes4(keccak256(bytes("transfer(address,uint256)")));
    } // 0xa9059cbb

    function getDataToCallTransfer(
        address someAddress,
        uint256 amount
    ) public pure returns (bytes memory) {
        return abi.encodeWithSelector(getselectorOne(), someAddress, amount);
    } //This function returns the data we need to put in the data field to call the transfer function

    function callTransferFunctionDirectly(
        address someAddress,
        uint256 amount
    ) public returns (bytes4, bool) {
        (bool success, bytes memory returnData) = address(this).call(
        // address(this).call(getDataToCallTransfer(someAddress, amount));
        abi.encodeWithSignature("transfer(address,uint256)", someAddress, amount));
        require(success, "Call failed");
        return (bytes4(returnData), success);
    } // This function calls the transfer function using the call method and the data we generated
}