// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {BigBank} from "../src/BigBank.sol";

contract BigBankTest is Test{
    BigBank public bigBank;

    address admin = makeAddr("admin");
    address alice = makeAddr("alice");
    function setUp() public{
        deal(alice, 10000 ether);
        vm.startPrank(admin);
        {
            bigBank = new BigBank(admin);
        }
        vm.stopPrank();
    }
    // 随机多少次：
    /// forge-config: default.fuzz.runs = 1000
    function testFuzz_Deposit(uint amount) public {
        vm.assume(amount > 0.001 ether && amount< 10000 ether);
        test_Deposit(amount);
        
    }

    function test_Deposit(uint amount) public{
        vm.startPrank(alice);
        {
            bytes memory data = abi.encodeWithSignature("deposite()");
            (bool result,) = address(bigBank).call{value:amount}(data);
            console.log("bigBank.depositeAccount()",bigBank.depositeAccount(alice));
            console.log("amount:",amount);
            console.log("result",result);
            assertEq(result,true,"deposit fail");
        }
        vm.stopPrank();
    }

    /// forge-config: default.fuzz.runs = 10000
    function testFuzz_withdrow(uint amount) public {
        vm.assume(amount > 0.001 ether && amount< 10000 ether);
        console.log("amount:",amount);
        vm.startPrank(alice);
        {
            bytes memory data = abi.encodeWithSignature("deposite()");
            (bool result,) = address(bigBank).call{value:amount}(data);
        }
        vm.stopPrank();
        vm.startPrank(admin);
        {
            bigBank.withdraw();
        }
        vm.stopPrank();
    }
}