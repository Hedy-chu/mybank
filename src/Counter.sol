// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Counter {
    uint256 public number;

    function setNumber(uint256 newNumber) public {
        // if (newNumber%3==0)
        // require(newNumber%3!=0,"invalid number");
        number = newNumber;
    }

    function increment() public {
        number++;
    }
}
