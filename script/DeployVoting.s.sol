// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import {Script, console} from "forge-std/Script.sol";
import {Voting} from "../src/Voting.sol";

contract DeployVoting is Script {
    Voting public voting;
    function run() public {
        vm.startBroadcast();
        voting = new Voting();
        console.log("Voting deployed at:", address(voting));

        vm.stopBroadcast();
    }
}
