// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PiggyBank {
    address public owner;

    event Deposit(address indexed sender, uint amount);
    event Withdraw(address indexed recipient, uint amount);
    event OwnerChanged(address indexed oldOwner, address indexed newOwner);

    constructor(address _owner) {
        if (_owner == address(0)) {
            owner = msg.sender;
        } else {
            owner = _owner;
        }
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint amount, address payable recipient) external {
        require(msg.sender == owner, "Only the owner can withdraw funds");
        require(amount > 0, "Amount must be greater than 0");
        require(address(this).balance >= amount, "Insufficient funds");

        // 将指定金额发送到接收者地址
        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Transfer failed");

        emit Withdraw(recipient, amount);
    }

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }

    function changeOwner(address newOwner) external {
        require(msg.sender == owner, "Only the current owner can change the owner");
        require(newOwner != address(0), "New owner cannot be the zero address");
        
        emit OwnerChanged(owner, newOwner);
        owner = newOwner;
    }
}
