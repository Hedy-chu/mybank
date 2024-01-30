// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";

import "../src/MyERC721.sol";


contract ERC721Script is Script {
    function setUp() public {}

    function run() public {
        vm.broadcast();
    }

    function deployNft() public {
        vm.broadcast();

        MyERC721 nft = new MyERC721();

        console.log("MyERC721:",address(nft));
    }
}