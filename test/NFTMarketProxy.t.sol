// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {MyTokenCallBack} from "../src/MyTokenCallBack.sol";
import {MyERC721} from "../src/MyERC721.sol";
import {NFTMarketV4} from "../src/NFTMarketV4.sol";

contract NFTMarketProxyTest is Test{
    // TransparentUpgradeableProxy proxy;
    bytes32 private constant _BUYBYSIG_TYPEHASH = keccak256("BuyBySig(uint256 tokenId,uint256 price)");
    bytes32 private constant TYPE_HASH = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
    bytes32 private DOMAIN_SEPARATOR;
    MyTokenCallBack myToken;
    MyERC721 erc721;
    NFTMarketV4 market;
    uint256 privateKey;
    address alice ;
    address admin = makeAddr("admin");
    address hedy = makeAddr("hedy");
    
   
    function setUp() public {
        vm.startPrank(admin);
       (alice, privateKey) = makeAddrAndKey("alice");
        vm.stopPrank();
        
        vm.startPrank(alice);
        myToken = new MyTokenCallBack();
        erc721 = new MyERC721();
        market = new NFTMarketV4(address(erc721),address(myToken),"NFTMarket","1");
        DOMAIN_SEPARATOR = keccak256(abi.encode(
            TYPE_HASH, // type hash
            keccak256(bytes("MyERC721")), // name
            keccak256(bytes("1")), // version
            block.chainid, // chain id
            erc721 // contract address
        ));
         vm.stopPrank();

        console.log("admin:",admin);
        console.log("alice:",alice);
        console.log("hedy:",hedy);
    }

     function test_mint(address to) public {
        // 铸造nft
        {
            erc721.mint(to);
            console.log("tokenId",erc721.currentTokenId());
            address owner = erc721.ownerOf(erc721.currentTokenId());
            assertEq(owner, to, "mint error");
        }

    }


    function test_tokenTransfer(address from, address to, uint amount) public {
        // token 转账
        vm.startPrank(from);
        {
            uint balanceBefore = myToken.balanceOf(to);
            myToken.transfer(to,amount);
            console.log("balanceBefore: balance:",balanceBefore, myToken.balanceOf(to));
            assertEq(myToken.balanceOf(to),balanceBefore + amount,"token transfer error");
        }
        vm.stopPrank();
    }

    function test_proxy() public {
        vm.startPrank(alice);
        test_mint(alice);
        test_tokenTransfer(alice,hedy,100000000);
        bytes32 digest = keccak256(abi.encodePacked(
            "\x19\x01",
            DOMAIN_SEPARATOR,
            keccak256(abi.encode(_BUYBYSIG_TYPEHASH, 0, 10000))
        )); 
        console.logBytes32(digest);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, digest);
        vm.stopPrank();

        vm.startPrank(hedy);
        console.log("v:",v);
        console.logBytes32(r);
        console.logBytes32(s);
        myToken.approve(address(market),10000);
        uint balanceOfHedy = myToken.balanceOf(hedy);
        uint balanceOfAlice = myToken.balanceOf(alice);
        console.log("balanceOfHedy:",balanceOfHedy);
        console.log("balanceOfAlice:",balanceOfAlice);
        address ownerBefer = erc721.ownerOf(0);
        console.log("ownerBefer:",ownerBefer);


        market.buyNftBySig(0,10000,v,r,s);
        
        uint balanceOfHedyAft = myToken.balanceOf(hedy);
        uint balanceOfAliceAft = myToken.balanceOf(alice);
        console.log("balanceOfHedyAft:",balanceOfHedyAft);
        console.log("balanceOfAliceAft:",balanceOfAliceAft);
        address owner = erc721.ownerOf(0);
        console.log("0owner:",owner);
        vm.stopPrank();
        
    }






}