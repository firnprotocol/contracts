// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {InnerProductVerifier} from "../src/InnerProductVerifier.sol";
import {DepositVerifier} from "../src/DepositVerifier.sol";
import {TransferVerifier} from "../src/TransferVerifier.sol";
import {WithdrawalVerifier} from "../src/WithdrawalVerifier.sol";
import {ERC20} from "../src/ERC20.sol";
import {Treasury} from "../src/Treasury.sol";
import {Firn} from "../src/Firn.sol";
import {FirnReader} from "../src/FirnReader.sol";

contract FirnScript is Script {
    Firn public counter;

    function setUp() public {}

    function run() public {
        // uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(); // deployerPrivateKey

        InnerProductVerifier ip = new InnerProductVerifier();
        DepositVerifier deposit = new DepositVerifier(ip);
        TransferVerifier transfer = new TransferVerifier(ip);
        WithdrawalVerifier withdrawal = new WithdrawalVerifier(ip);

        ERC20 token = new ERC20("Firn Token", "FIRN");
        Treasury treasury = new Treasury(token);

        Firn firn = new Firn(deposit, transfer, withdrawal, address(treasury));
        FirnReader reader = new FirnReader(firn);

        vm.stopBroadcast();
    }
}
