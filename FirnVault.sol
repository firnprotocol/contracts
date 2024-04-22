// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "./ERC20.sol";

contract FirnVault {
    address public constant FIRN_MULTISIG = 0xa14664a2E58e804669E9fF1DFbC1bD981E13B0dC;
    ERC20 public constant firnToken = ERC20(0xDDEA19FCE1E52497206bf1969D2d56FeD85aFF5c);
    uint256 public immutable FIRN_AMOUNT;
    uint256 public immutable LOCKUP_DAYS;
    address public immutable PARTICIPANT;

    uint256 public vestingDate;
    bool public lockStatus = false;

    constructor(address participant, uint256 firnAmount, uint256 lockupDays) {
        PARTICIPANT = participant;
        FIRN_AMOUNT = firnAmount;
        LOCKUP_DAYS = lockupDays;
    }

    receive() external payable { // receive ether, e.g., as a payout from Firn fees.

    }

    function sweepFunds() external {
        (bool success, ) = payable(PARTICIPANT).call{value: address(this).balance}("");
        require(success, "Transfer failed.");
    }

    function initiateLock() external {
        require(!lockStatus, "Token already locked."); // this can easily be avoided, just as an additional safety measure
        lockStatus = true;

        vestingDate = block.timestamp + LOCKUP_DAYS * 1 days; // kick off lockup
        firnToken.transferFrom(FIRN_MULTISIG, address(this), FIRN_AMOUNT * 1 ether);
    }

    function vest() external {
        require(block.timestamp >= vestingDate, "Hasn't vested yet.");
        firnToken.transfer(PARTICIPANT, firnToken.balanceOf(address(this)));
    }
}