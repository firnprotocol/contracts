// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "./ERC20.sol";

contract FirnOTC {
    address public constant FIRN_MULTISIG = 0xa14664a2E58e804669E9fF1DFbC1bD981E13B0dC;
    ERC20 public constant firnToken = ERC20(0xDDEA19FCE1E52497206bf1969D2d56FeD85aFF5c);
    uint256 public immutable ETHER_AMOUNT;
    uint256 public immutable FIRN_AMOUNT;
    uint256 public immutable LOCKUP_DAYS;

    address public buyer = FIRN_MULTISIG; // init. to ourselves. for edge case where someone sends funds before deal
    uint256 public vestingDate;
    bool public dealStatus = false;

    constructor(uint256 etherAmount, uint256 firnAmount, uint256 lockupDays) {
        ETHER_AMOUNT = etherAmount;
        FIRN_AMOUNT = firnAmount;
        LOCKUP_DAYS = lockupDays;
    }

    receive() external payable { // receive ether, e.g., as a payout from Firn fees.

    }

    function sweepFunds() external { // callable by anyone; sweeps balance to buyer
        (bool success, ) = payable(buyer).call{value: address(this).balance}("");
        require(success, "Transfer failed.");
    }

    function executeDeal() external payable {
        buyer = msg.sender;
        require(!dealStatus, "Deal already done."); // this can easily be avoided, just as an additional safety measure
        require(msg.value == ETHER_AMOUNT * 1 ether, "Wrong amount of ether supplied.");
        dealStatus = true; // prevents Firn from exiting on line 48

        vestingDate = block.timestamp + LOCKUP_DAYS * 1 days; // kick off lockup
        firnToken.transferFrom(FIRN_MULTISIG, address(this), FIRN_AMOUNT * 1 ether);
        (bool success, ) = payable(FIRN_MULTISIG).call{value: msg.value}("");
        require(success, "Transfer failed.");
    }

    function vest() external {
        require(block.timestamp >= vestingDate, "Hasn't vested yet.");
        firnToken.transfer(buyer, firnToken.balanceOf(address(this)));
    }
}