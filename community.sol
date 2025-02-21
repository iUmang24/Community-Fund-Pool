// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CommunityFundPool {
    address public owner;
    uint256 public totalFunds;

    event FundsDeposited(address indexed contributor, uint256 amount);
    event FundsDistributed(address indexed recipient, uint256 amount);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
        emit OwnershipTransferred(address(0), msg.sender);
    }

    // Allow users to contribute funds
    function contribute() external payable {
        require(msg.value > 0, "Must send ETH");

        totalFunds += msg.value;
        emit FundsDeposited(msg.sender, msg.value);
    }

    // Admin distributes funds to a research project
    function distributeFunds(address payable recipient, uint256 amount) external onlyOwner {
        require(amount <= address(this).balance, "Insufficient funds");
        require(recipient != address(0), "Invalid recipient");

        totalFunds -= amount;
        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Transfer failed");

        emit FundsDistributed(recipient, amount);
    }

    // Get contract balance
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    // Transfer ownership
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Invalid new owner");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    // Allow contract to receive ETH
    receive() external payable {
        
    }
}
