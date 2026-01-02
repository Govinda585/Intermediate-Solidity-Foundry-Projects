// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Script} from "forge-std/Script.sol";
import {LockedWallet} from "../src/LockedWallet.sol";
contract DeployLockedWallet is Script {
    function run() external {
        vm.startBroadcast();
        LockedWallet lockedWallet = new LockedWallet();
        vm.stopBroadcast();
    }
}
