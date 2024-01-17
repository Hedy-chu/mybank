// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {MyTokenCallBack} from "../src/MyTokenCallBack.sol";
import {MyERC721} from "../src/MyERC721.sol";
import {NFTMarket} from "../src/NFTMarket.sol";

contract NFTMarketTest is Test {
    NFTMarket market;
    MyTokenCallBack myToken;
    MyERC721 erc721;

    address admin = makeAddr("admin");
    address alice = makeAddr("alice");
    address ben = makeAddr("ben");
    address hedy = makeAddr("hedy");
    /**
     * 初始化方法
     */
    function setUp() public {
        deal(admin,10000 ether);
        deal(hedy,10000 ether);
        deal(alice,100 ether);
        deal(ben,100 ether);
        
        vm.prank(admin);
        myToken = new MyTokenCallBack();
        erc721 = new MyERC721();
        market = new NFTMarket(address(erc721),address(myToken));
        
    }

    function test_Owner() public {
        assertEq(myToken.owner(), admin, "expect owner is myadmin");
    }

    function test_mintNft() public{

        // 铸造nft
        vm.startPrank(admin);
        erc721.mint(alice);
        address owner = erc721.ownerOf(0);
        console.log("alice",alice);
        console.log("owner",owner);
        vm.stopPrank();

        // list
        vm.startPrank(alice);
        erc721.approve(address(market), 0);
        market.list(0,10000);
        market.listNft(0,alice);
        console.log("price",market.listNft(0,alice));
        vm.stopPrank();

        // token 转账
        vm.startPrank(admin);
        myToken.transfer(hedy,1000000);
        myToken.balanceOf(hedy);
        console.log("hedy balance",myToken.balanceOf(hedy));
        vm.stopPrank();

        // hedy buy
        vm.startPrank(hedy);
        // 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000004b20993bc481177ec7e8f571cecae8a9e22c02db
        myToken.transferForBuyNft(address(market),10000, abi.encode("abi(uint,address)",0,address(hedy)));
        address newOwner = erc721.ownerOf(0);
        assertEq(newOwner, erc721.ownerOf(0), "exchange owner error");
        console.log("newOwner",newOwner);
        assertEq(myToken.balanceOf(alice), 10000, "transfer error");
        vm.stopPrank();








    }


}