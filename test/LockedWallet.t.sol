// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import {Test, console} from "forge-std/Test.sol";
import {LockedWallet} from "../src/LockedWallet.sol";

contract LockedWalletTest is Test {
    LockedWallet public lockedWallet;
    address USER = makeAddr("user");
    function setUp() public {
        lockedWallet = new LockedWallet();
        vm.warp(1_700_000_000);
    }

    function testRevertOnDepositZero() public {
        vm.expectRevert("Cannot deposit 0");
        lockedWallet.deposit();
    }
    function testDeposit() public {
        assertEq(lockedWallet.getBalance(USER), 0);
        assertEq(lockedWallet.getUnlockTime(USER), 0);
        vm.deal(USER, 10 ether);
        vm.prank(USER);
        lockedWallet.deposit{value: 5 ether}();
        assertEq(lockedWallet.getBalance(USER), 5 ether);
        assertEq(lockedWallet.getUnlockTime(USER), block.timestamp + 600);
    }

    function testRevertOnUnlockedTimeNotExceeded() public {
        vm.deal(USER, 5 ether);
        vm.startPrank(USER);
        lockedWallet.deposit{value: 4 ether}();
        vm.expectRevert(LockedWallet.TimeNotExceeded.selector);
        lockedWallet.withdraw();
        vm.stopPrank();
    }

    function testRevertOnWithdrawWithoutFund() public {
        vm.expectRevert("No funds to withdraw");
        lockedWallet.withdraw();
    }

    function testWithdraw() public {
        vm.deal(USER, 10 ether);
        vm.startPrank(USER);

        lockedWallet.deposit{value: 5 ether}();
        assertEq(lockedWallet.getBalance(USER), 5 ether);
        assertEq(lockedWallet.getUnlockTime(USER), block.timestamp + 600);
        vm.warp(block.timestamp + 600);
        lockedWallet.withdraw();
        vm.stopPrank();
        assertEq(lockedWallet.getBalance(USER), 0);
        assertEq(lockedWallet.getUnlockTime(USER), 0);
    }

    function testGetBalance() public {
        vm.deal(USER, 10 ether);
        vm.startPrank(USER);
        lockedWallet.deposit{value: 5 ether}();
        assertEq(lockedWallet.getBalance(USER), 5 ether);
        vm.stopPrank();
    }
    function testGetUnlockTime() public {
        vm.deal(USER, 10 ether);
        vm.startPrank(USER);
        lockedWallet.deposit{value: 5 ether}();
        assertEq(lockedWallet.getUnlockTime(USER), block.timestamp + 600);
        vm.stopPrank();
    }
}
