// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./Bank.sol";

contract BigBank is Bank{

    uint constant DEPOSITE_LIMIT = 0.001 ether;

    constructor(address _owner) {
        owner = _owner;
    }
    
    modifier checkAmount(uint amount){
        require(amount >=  DEPOSITE_LIMIT,"Deposits should be greater than 0.001ether");
        _;
    }
    function deposite()public payable override checkAmount(msg.value) returns(bool){
        return super.deposite();
    }

}