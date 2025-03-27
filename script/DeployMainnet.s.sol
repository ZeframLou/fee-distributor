// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.0;

import "forge-std/Script.sol";

import {CREATE3Script} from "./base/CREATE3Script.sol";
import {FeeDistributor} from "../src/FeeDistributor.sol";

contract DeployScript is CREATE3Script {
    constructor() CREATE3Script(vm.envString("VERSION")) {}

    function run() external returns (FeeDistributor deployed, bytes32 salt) {
        // Select mainnet fork
        vm.createSelectFork("mainnet");

        uint256 deployerPrivateKey = uint256(vm.envBytes32("PRIVATE_KEY"));

        address votingEscrow = vm.envAddress("VOTING_ESCROW_MAINNET");
        uint256 startTime = vm.envUint("START_TIME_MAINNET");

        salt = getCreate3SaltFromEnv("FeeDistributor");

        vm.startBroadcast(deployerPrivateKey);

        deployed = FeeDistributor(
            create3.deploy(salt, bytes.concat(type(FeeDistributor).creationCode, abi.encode(votingEscrow, startTime)))
        );

        vm.stopBroadcast();
    }
}
