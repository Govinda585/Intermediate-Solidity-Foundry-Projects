// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import {Script} from "forge-std/Script.sol";
import {BurnToken} from "../src/BurnToken.sol";
contract DeployBurnToken is Script {
    BurnToken public burnToken;

    function run() public {
        vm.startBroadcast();
        burnToken = new BurnToken(1000);
        vm.stopBroadcast();
    }
}
