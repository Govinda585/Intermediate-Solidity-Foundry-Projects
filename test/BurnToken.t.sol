// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {BurnToken} from "../src/BurnToken.sol";

contract BurnTokenTest is Test {
    event Burned(address indexed burner, address indexed to, uint256 amount);

    BurnToken public burnToken;
    string public constant TOKEN_NAME = "BITCOIN";
    string public constant TOKEN_SYMBOL = "BTC";

    uint256 public initialSupply = 1000;

    function setUp() public {
        burnToken = new BurnToken(initialSupply);
    }

    function testRevertOnBurnAmountZero() public {
        vm.expectRevert(BurnToken.BurnAmountZero.selector);
        burnToken.burn(0);
    }

    function testRevertOnInsufficientBalanace() public {
        address USER = makeAddr("user");

        burnToken.transfer(USER, 100);
        vm.startPrank(USER);

        vm.expectRevert(BurnToken.InsufficientBalance.selector);
        burnToken.burn(200);
        vm.stopPrank();
    }

    function testBurn() public {
        address USER = makeAddr("user");
        burnToken.transfer(USER, 200);
        vm.startPrank(USER);
        burnToken.burn(100);
        vm.stopPrank();
        assertEq(burnToken.total_supply(), initialSupply - 100);
        assertEq(burnToken.balanceOf(USER), 100);
    }

    function testEmitEventOnBurn() public {
        vm.expectEmit(true, true, false, true);
        emit Burned(address(this), address(0x0), 100);
        burnToken.burn(100);
    }

    function testRevertOnInsufficientBalanceOnTransfer() public {
        vm.expectRevert(BurnToken.InsufficientBalance.selector);
        burnToken.transfer(address(0x12), 10000);
    }

    function testRevertOnInvalidAddressOnTransfer() public {
        vm.expectRevert(BurnToken.InvalidAddress.selector);
        burnToken.transfer(address(0x0), 100);
    }

    function testTranfer() public {
        burnToken.transfer(address(0x22), 100);
        assertEq(burnToken.balanceOf(address(this)), 900);
        assertEq(burnToken.balanceOf(address(0x22)), 100);
    }
}
