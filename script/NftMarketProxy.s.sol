// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Upgrades, Options} from "openzeppelin-foundry-upgrades/Upgrades.sol";

import "../src/NFTMarketV2.sol";
import "./BaseScript.s.sol";


contract NFTMarketScript is BaseScript {

    // function run() public {
    //     vm.broadcast();
    // }

    function deployProxy() public broadcaster{
        Options memory opts;
        // vm.broadcast();

       address proxy = Upgrades.deployTransparentProxy(
        "NFTMarketV2.sol",
        deployer,
        abi.encodeCall(NFTMarketV2.initialize, (0x5FbDB2315678afecb367f032d93F642f64180aa3,0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512)),
        opts
        );

        console.log("proxy:",address(proxy));
    }
}