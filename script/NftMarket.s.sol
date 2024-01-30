// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";

import "../src/NFTMarket.sol";


contract NFTMarketScript is Script {
    function setUp() public {}

    function run() public {
        vm.broadcast();
    }

    function deployMarket() public {
        vm.broadcast();

        NFTMarket market = new NFTMarket(0x5FbDB2315678afecb367f032d93F642f64180aa3,0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512);

        console.log("market:",address(market));
    }
}