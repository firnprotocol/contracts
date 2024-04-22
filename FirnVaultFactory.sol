// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "./FirnVault.sol";

contract FirnVaultFactory {
    event VaultInitiated(address vaultAddress);

    function initiateVault(address participant, uint256 firnAmount, uint256 lockupDays) external {
        FirnVault deal = new FirnVault(participant, firnAmount, lockupDays);
        emit VaultInitiated(address(deal));
    }
}