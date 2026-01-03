// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

contract BurnToken {
    // Implement a contract that burns tokens (reduces total supply).

    string public constant TOKEN_NAME = "BITCOIN";
    string public constant TOKEN_SYMBOL = "BTC";
    uint256 public total_supply;

    mapping(address => uint256) public balanceOf;
    address public owner;

    // EVENT
    event Burned(address indexed burner, address indexed to, uint256 amount);

    // ERROR
    error BurnAmountZero();
    error InsufficientBalance();
    error InvalidAddress();

    constructor(uint256 _initialSupply) {
        total_supply = _initialSupply;
        owner = msg.sender;
        balanceOf[msg.sender] = _initialSupply;
    }

    function burn(uint256 _amount) external {
        if (_amount <= 0) revert BurnAmountZero();
        if (balanceOf[msg.sender] < _amount) revert InsufficientBalance();
        balanceOf[msg.sender] -= _amount;
        total_supply -= _amount;
        emit Burned(msg.sender, address(0x0), _amount);
    }

    function transfer(address to, uint256 _amount) external {
        if (balanceOf[msg.sender] < _amount) revert InsufficientBalance();
        if (to == address(0x0)) revert InvalidAddress();

        balanceOf[msg.sender] -= _amount;
        balanceOf[to] += _amount;
    }
}
