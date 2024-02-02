// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Upgrades, Options} from "openzeppelin-foundry-upgrades/Upgrades.sol";

import "../src/NFTMarketV3.sol";
import "./BaseScript.s.sol";

/**
 * @title 更换逻辑合约
 * @author 
 * @notice 
 */
contract NFTMarketV3Script is BaseScript {

    function deployV3Proxy() public {
       vm.startBroadcast(deployer);
       Options memory opts;
    //   opts.unsafeSkipAllChecks = true;
        opts.referenceContract = "NFTMarketV2.sol";

        // proxy: 0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9
        Upgrades.upgradeProxy(0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9, "NFTMarketV3.sol", "", opts);
        
        vm.stopBroadcast();
    
    }

    function getAddr() public{
        vm.startBroadcast(deployer);
        address implAddr = Upgrades.getImplementationAddress(0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9);
        console.log("implAddr:",implAddr);
        vm.stopBroadcast();
    }
}