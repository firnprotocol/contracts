// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "./FirnOTC.sol";

contract FirnOTCFactory {
    event DealInitiated(address dealAddress);

    function initiateDeal(uint256 etherAmount, uint256 firnAmount, uint256 lockupDays) external {
        FirnOTC deal = new FirnOTC(etherAmount, firnAmount, lockupDays);
        emit DealInitiated(address(deal));
    }
}