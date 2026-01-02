// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

// Create a time-locked wallet that releases funds after a deadline.

contract LockedWallet {
    mapping(address => uint256) private balanceOf;
    address payable public owner;

    mapping(address => uint256) private unlockTime;

    error TimeNotExceeded();
    error FailedTransaction();

    uint256 public constant LOCK_INTERVAL = 600; // 10 minutes
    constructor() {
        owner = payable(msg.sender);
    }

    function deposit() external payable {
        require(msg.value > 0, "Cannot deposit 0");

        balanceOf[msg.sender] += msg.value;
        unlockTime[msg.sender] = block.timestamp + LOCK_INTERVAL;
    }

    function withdraw() public {
        if (block.timestamp < unlockTime[msg.sender]) revert TimeNotExceeded();
        uint256 fund = balanceOf[msg.sender];
        require(fund > 0, "No funds to withdraw");
        balanceOf[msg.sender] = 0;
        unlockTime[msg.sender] = 0;

        (bool success, ) = payable(msg.sender).call{value: fund}("");

        if (!success) revert FailedTransaction();
    }

    // View balance of a user
    function getBalance(address user) external view returns (uint256) {
        return balanceOf[user];
    }

    // View unlock time of a user
    function getUnlockTime(address user) external view returns (uint256) {
        return unlockTime[user];
    }

    receive() external payable {}

    fallback() external payable {}
}

/* 
deposit() - deposit fund and set interval
withdrawFund() - withdraw fund if block.timestamp is greater than set interval
*/
