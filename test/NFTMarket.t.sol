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
        
        vm.startPrank(admin);
        myToken = new MyTokenCallBack();
        erc721 = new MyERC721();
        market = new NFTMarket(address(erc721),address(myToken));
        vm.stopPrank();
        
    }

    function test_Owner() public {
        console.log("erc721 owner:", erc721.owner());
        assertEq(myToken.owner(), admin, "expect owner is myadmin");
    }

    function test_mint(address to) public {
        // 铸造nft
        vm.startPrank(admin);
        {
            erc721.mint(to);
            console.log("tokenId",erc721.currentTokenId());
            address owner = erc721.ownerOf(erc721.currentTokenId());
            assertEq(erc721.ownerOf(erc721.currentTokenId()), to, "mint error");
        }
        vm.stopPrank();
    }

    function test_list(address from, uint tokenId, uint amount) public {
        // list
        vm.startPrank(from);
        {
            erc721.approve(address(market), tokenId);
            market.list(tokenId,amount);
            assertEq(market.listNft(tokenId,from),amount,"list error");
            assertTrue(erc721.ownerOf(tokenId) == address(market),"list owner error");
        }
        vm.stopPrank();
    }


    function test_tokenTransfer(address from, address to, uint amount) public {
        // token 转账
        vm.startPrank(from);
        {
            uint balanceBefore = myToken.balanceOf(to);
            myToken.transfer(to,amount);
            console.log("hedy balanceBefore: balance:",balanceBefore, myToken.balanceOf(to));
            assertEq(myToken.balanceOf(to),balanceBefore + amount,"token transfer error");
        }
        vm.stopPrank();
    }

    function test_buyNft(address buyer, uint tokenId, uint amount) public{
        // hedy buy
        vm.startPrank(buyer);
        {
            uint balanceBefore = myToken.balanceOf(alice);
            myToken.transferForBuyNft(address(market),amount, abi.encode(tokenId,address(buyer)));
            address newOwner = erc721.ownerOf(tokenId);
            assertEq(buyer, erc721.ownerOf(tokenId), "exchange owner error");
            console.log("newOwner:",newOwner);
            assertEq(myToken.balanceOf(alice), balanceBefore+amount, "transfer error");
        }
        vm.stopPrank();
    }

    function test_mintNft() public{
        test_mint(alice);
        test_list(alice, erc721.currentTokenId(), 10000);
        test_tokenTransfer(admin,hedy,10 ether);
        console.log("hedy address",hedy);
        test_buyNft(hedy,erc721.currentTokenId(),10000);
    }

    function test_mintOnlyOwner() public{
        vm.prank(admin);
        erc721.mint(alice);

        vm.prank(alice);
        erc721.mint(alice);
    }

    // function test_revert() public{
    //     market.list(1, 1000);
    //     vm.expectRevert(NFTMarket.notOnSale.selector);
    // }

    /// forge-config: default.fuzz.runs = 10000
    function testFuzz_mintNft(uint amount) public{
        vm.assume(amount >0 && amount < 10 ether);
        test_mint(alice);
        test_list(alice, erc721.currentTokenId(), amount);
        test_tokenTransfer(admin,hedy,10 ether);
        test_buyNft(hedy,erc721.currentTokenId(),amount);
    }


}