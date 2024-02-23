// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import {console} from "forge-std/Test.sol";

contract Bank {
    mapping(address => uint) public depositeAccount;
    address[3] public topAccount;
    address public owner;
    bool public rept = false;
    error withdrawFail();

    constructor() {
        owner = msg.sender;
    }

    // 接收eth
    receive() external payable {}

    /**
      存款合约
    **/
    function deposite() public payable virtual returns (bool) {
        require(msg.value > 0, "The deposit should be greater than zero");
        depositeAccount[msg.sender] += msg.value;

        for (uint i = 0; i < 3; i++) {
            if (topAccount[i] == msg.sender) {
                rept = true;
                sort();
                break;
            }
        }
        if (rept == false) {
            topAccount[0] = msg.sender;
            sort();
        }
        return true;
    }

    function sort() public {
        uint256 n = topAccount.length;

        for (uint256 i = 0; i < n - 1; i++) {
            for (uint256 j = 0; j < n - i - 1; j++) {
                uint amount = depositeAccount[topAccount[j]];
                uint nextAmount = depositeAccount[topAccount[j + 1]];
                if (amount > nextAmount) {
                    (topAccount[j], topAccount[j + 1]) = (
                        topAccount[j + 1],
                        topAccount[j]
                    );
                }
            }
        }
    }

    function withdraw() public virtual {
        require(owner == msg.sender, "only owner can withdraw");
        require(address(this).balance > 0, "not sufficient funds");
        // address payable sender = payable (msg.sender);
        console.log(msg.sender);
        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        if (!success) {
            revert withdrawFail();
        }
    }

    function balance() public view returns (uint) {
        return address(this).balance;
    }
}
