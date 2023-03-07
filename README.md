# Binance-BEP20-MultiSender

The BatchTransfer contract contains several functions that allow users to transfer tokens to multiple recipients in a single transaction, as well as functions for managing the whitelist and blacklist of allowed and disallowed addresses:

constructor(address _token): Initializes the contract with the address of a BEP20 token contract that the contract will use to transfer tokens.

transferOwnership(address newOwner) external: Allows the current owner of the contract to transfer ownership to a new address.

setFeePercentage(uint256 _feePercentage) external: Allows the owner of the contract to set the fee percentage that will be charged for each transfer.

addToWhitelist(address _address) external: Allows the owner of the contract to add an address to the whitelist of allowed addresses.

removeFromWhitelist(address _address) external: Allows the owner of the contract to remove an address from the whitelist.

addToBlacklist(address _address) external: Allows the owner of the contract to add an address to the blacklist of disallowed addresses.

removeFromBlacklist(address _address) external: Allows the owner of the contract to remove an address from the blacklist.

batchTransfer(address[] calldata recipients, uint256[] calldata amounts) external: Allows users to send tokens to up to 50 addresses at once. The function verifies that the recipients and amounts arrays have the same length and that the number of recipients is no more than 50. It then calculates the total amount of tokens to be sent, subtracts the fee percentage, transfers the total amount of tokens to the contract, and then transfers the specified amounts of tokens to each recipient. Finally, it transfers the fee to the contract owner.

getBalance() external view returns (uint256): Returns the balance of the contract in tokens.

withdrawTokens() external: Allows the owner of the contract to withdraw any remaining tokens from the contract. It checks that the caller is the owner of the contract, and then transfers the remaining tokens to the contract owner's address.
