// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {MyTokenCallBack} from "../src/MyTokenCallBack.sol";
import {MyERC721} from "../src/MyERC721.sol";
import {AirdopMerkleNFTMarket} from "../src/AirdopMerkleNFTMarket.sol";
import {Counter} from "../src/Counter.sol";

contract AirdopMerkleNFTMarketTest is Test {
    bytes32 private constant TYPE_HASH = 
    keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
    bytes32 private constant PERMIT_TYPEHASH =
        keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
    bytes32 private DOMAIN_SEPARATOR;
    AirdopMerkleNFTMarket public market;
    MyTokenCallBack public token;
    MyERC721 public nft;
    Counter public counter;
    address alice;
    address admin; // 项目方
    uint256 aliceKey;
    uint256 adminKey;

    bytes32 root = 0xeeefd63003e0e702cb41cd0043015a6e26ddb38073cc6ffeb0ba3e808ba8c097;
    bytes32 leaf = 0x5931b4ed56ace4c46b68524cb5bcbf4195f1bbaacbe5228fbd090546c88dd229;
    bytes32[] proof;

    AirdopMerkleNFTMarket.Call[] public calls;

    function setUp() public{
        (alice, aliceKey) = makeAddrAndKey("alice");
        (admin, adminKey) = makeAddrAndKey("admin");
        vm.startPrank(admin);
        {
            counter = new Counter();
            token= new MyTokenCallBack();
            nft = new MyERC721();
            market = new AirdopMerkleNFTMarket(address(nft),address(token),root);
            DOMAIN_SEPARATOR = keccak256(abi.encode(
                TYPE_HASH, // type hash
                keccak256(bytes("MyToken")), // name
                keccak256(bytes("1")), // version
                block.chainid, // chain id
                token // contract address
            ));
            proof.push(0x999bf57501565dbd2fdcea36efa2b9aef8340a8901e3459f4a4c926275d36cdb);
            proof.push(0x4726e4102af77216b09ccd94f40daa10531c87c4d60bba7f3b3faf5ff9f19b3c);

        }
        vm.stopPrank();
    }

    function test_permit() public  {
        deal(address(token), alice, 100000);
        
        vm.startPrank(alice);
        {
            bytes32 digest = keccak256(abi.encodePacked(
                "\x19\x01",
                DOMAIN_SEPARATOR,
                keccak256(abi.encode(PERMIT_TYPEHASH, address(alice), market, 1000, token.nonces(address(alice)),1740123868000))
            )); 
            console.logBytes32(digest);
            (uint8 v, bytes32 r, bytes32 s) = vm.sign(aliceKey, digest);
            market.permitPrePay(address(alice),1000,1740123868000,v,r,s);
        }
    }

    function test_claimNFT() public {
        vm.startPrank(admin);
        {
            nft.mint(admin);
            nft.approve(address(market),0);
        }
        vm.stopPrank();
        vm.startPrank(alice);
        {
            market.claimNFT(address(alice),0,1000,leaf,proof);
        }
        vm.stopPrank();
    }

    function test_total() public {
        test_permit();
        test_claimNFT();
    }

    function test_mutiCall() public {
        deal(address(token), alice, 100000);
        vm.startPrank(admin);
        {
            nft.mint(admin);
            nft.approve(address(market),0);
        }
        vm.stopPrank();
        vm.startPrank(alice);
        {
            bytes32 digest = keccak256(abi.encodePacked(
                "\x19\x01",
                DOMAIN_SEPARATOR,
                keccak256(abi.encode(PERMIT_TYPEHASH, address(alice), market, 1000, token.nonces(address(alice)),1740123868000))
            )); 
            console.logBytes32(digest);
            (uint8 v, bytes32 r, bytes32 s) = vm.sign(aliceKey, digest);
            calls.push(
                AirdopMerkleNFTMarket.Call({
                    target: address(market),
                    callData: abi.encodeWithSignature("permitPrePay(address,uint256,uint256,uint8,bytes32,bytes32)",address(alice),1000,1740123868000,v,r,s)})
            );
            calls.push(
                AirdopMerkleNFTMarket.Call({
                    target: address(market),
                    callData: abi.encodeWithSignature("claimNFT(address,uint256,uint256,bytes32,bytes32[])",address(alice),0,1000,leaf,proof)}
            ));
            market.aggregate(calls);
            asssertEq(nft.ownerOf(0), alice);
            vm.stopPrank();
        }
    }
}
