// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";

import "../src/Counter.sol";
contract CounterScript is Script {
    function setUp() public {}

    function run() public {
        vm.broadcast();
    }

    function deployCounter() public {
        vm.broadcast();

        Counter c = new Counter();

        console.log("Counter:",address(c));
    }

    function setNumber() public  {
        
        Counter c = Counter(0x5FbDB2315678afecb367f032d93F642f64180aa3);
       
        vm.broadcast();
        c.setNumber(12);
        c.increment();

        console.log("number:",c.number());
    }
}
