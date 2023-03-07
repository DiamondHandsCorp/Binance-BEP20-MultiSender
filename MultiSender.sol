// SPDX-License-Identifier: MIT
// Programmed by Sean Pepper
pragma solidity ^0.8.0;

// Interface for BEP20 tokens
interface IBEP20 {
    function transfer(address to, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
}

contract BatchTransfer {
    address public owner;
    uint256 public feePercentage = 250; // 2.5% fee
    IBEP20 public token;
    mapping (address => bool) public whitelist; // A mapping of addresses that are allowed to receive tokens
    mapping (address => bool) public blacklist; // A mapping of addresses that are not allowed to receive tokens

    constructor(address _token) {
        owner = msg.sender; // Set the contract owner to the address that deployed the contract
        token = IBEP20(_token); // Instantiate the BEP20 token contract
    }
    // Allows the owner to transfer ownership of the contract
    function transferOwnership(address newOwner) external {
        require(msg.sender == owner, "Only the owner can transfer ownership"); // Only the owner can call this function
        require(newOwner != address(0), "New owner cannot be zero address"); // Ensure that the new owner address is not the zero address
        owner = newOwner; // Set the new owner address
    }

    // Allows the owner to change the fee percentage
    function setFeePercentage(uint256 _feePercentage) external {
        require(msg.sender == owner, "Only owner can change fee percentage"); // Only the owner can call this function
        feePercentage = _feePercentage; // Set the new fee percentage
    }

    // Allows the owner to add an address to the whitelist
    function addToWhitelist(address _address) external {
        require(msg.sender == owner, "Only owner can add addresses to whitelist"); // Only the owner can call this function
        whitelist[_address] = true; // Add the address to the whitelist
    }

    // Allows the owner to remove an address from the whitelist
    function removeFromWhitelist(address _address) external {
        require(msg.sender == owner, "Only owner can remove addresses from whitelist"); // Only the owner can call this function
        whitelist[_address] = false; // Remove the address from the whitelist
    }

    // Allows the owner to add an address to the blacklist
    function addToBlacklist(address _address) external {
        require(msg.sender == owner, "Only owner can add addresses to blacklist"); // Only the owner can call this function
        blacklist[_address] = true; // Add the address to the blacklist
    }

    // Allows the owner to remove an address from the blacklist
    function removeFromBlacklist(address _address) external {
        require(msg.sender == owner, "Only owner can remove addresses from blacklist"); // Only the owner can call this function
        blacklist[_address] = false; // Remove the address from the blacklist
    }
    // Allows users to send tokens to up to 50 addresses
    function batchTransfer(address[] calldata recipients, uint256[] calldata amounts) external {
        require(recipients.length == amounts.length, "Recipients and amounts arrays must have the same length"); // Ensure that the recipients and amounts arrays have the same length
        require(recipients.length <= 50, "Cannot send to more than 50 recipients at once"); // Ensure that the number of recipients is no more than 50

        uint256 totalAmount = 0; // Initialize a variable to hold the total amount of tokens to send
        for (uint256 i = 0; i < recipients.length; i++) {
            totalAmount += amounts[i]; // Add the amount of tokens to send to each recipient to the total amount
        }

        uint256 fee = (totalAmount * feePercentage) / 10000; // Calculate the fee to charge as a percentage of the total amount

        require(token.allowance(msg.sender, address(this)) >= totalAmount, "Insufficient allowance"); // Ensure that the sender has approved the contract to spend at least the total amount of tokens to be transferred
        token.transferFrom(msg.sender, address(this), totalAmount); // Transfer the total amount of tokens from the sender to the contract

        // Transfer the specified amounts of tokens to each recipient
        for (uint256 i = 0; i < recipients.length; i++) {
            require(token.transfer(recipients[i], amounts[i]), "Transfer failed");
        }

        // Transfer the fee to the contract owner
        if (fee > 0) {
            require(token.transfer(owner, fee), "Transfer failed");
        }
    }
    // Returns the balance of the contract in tokens
    function getBalance() external view returns (uint256) {
        return token.balanceOf(address(this));
    
    }    
    // Allows the owner to withdraw any remaining tokens from the contract
    function withdrawTokens() external {
        require(msg.sender == owner, "Only owner can withdraw tokens"); // Only the owner can call this function
        uint256 balance = token.balanceOf(address(this)); // Get the balance of the contract
        require(balance > 0, "Contract has no tokens to withdraw"); // Ensure that the contract has tokens to withdraw
        require(token.transfer(owner, balance), "Transfer failed"); // Transfer the remaining tokens to the contract owner
    }
}
