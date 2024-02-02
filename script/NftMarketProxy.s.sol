// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Upgrades, Options} from "openzeppelin-foundry-upgrades/Upgrades.sol";

import "../src/NFTMarketV2.sol";
import "./BaseScript.s.sol";

/**
 * @title 透明代理部署  生成逻辑合约、代理合约、管理合约地址
 * @author 
 * @notice 
 */
contract NFTMarketScript is BaseScript {

    function deployProxy() public broadcaster{
       Options memory opts;
       bytes32  ADMIN_SLOT = bytes32(uint(keccak256("eip1967.proxy.admin")) - 1);

       address proxy = Upgrades.deployTransparentProxy(
        "NFTMarketV2.sol",
        deployer,
        abi.encodeCall(NFTMarketV2.initialize, (0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512,0x5FbDB2315678afecb367f032d93F642f64180aa3)),
        opts
        );

        // bytes32 ownerAddr = vm.load(address(proxy),bytes32(uint(keccak256("eip1967.proxy.admin")) - 1));
        // console.logBytes32(ownerAddr);

        address ownerAddr = address(uint160(uint256(bytes32(vm.load(address(proxy), ADMIN_SLOT)))));

        console.log("proxy:",address(proxy));
        console.log("ownerAddr:",ownerAddr);
    
    }

}