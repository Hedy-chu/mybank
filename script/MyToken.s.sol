// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";

import "../src/MyTokenCallBack.sol";


contract MyTokenScript is Script {
    function setUp() public {}

    function run() public {
        vm.broadcast();
    }

    function deployToken() public {
        vm.broadcast();

        MyTokenCallBack token = new MyTokenCallBack();

        console.log("MyTokenCallBack:",address(token));
    }
}