// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.0;

import {CREATE3Factory} from "create3-factory/CREATE3Factory.sol";

import "forge-std/Script.sol";

import {FeeDistributor} from "../src/FeeDistributor.sol";

contract DeployScript is Script {
    function run() external returns (FeeDistributor deployed) {
        uint256 deployerPrivateKey = uint256(vm.envBytes32("PRIVATE_KEY"));
        CREATE3Factory create3 = CREATE3Factory(0x9fBB3DF7C40Da2e5A0dE984fFE2CCB7C47cd0ABf);
        address votingEscrow = vm.envAddress("VOTING_ESCROW_MAINNET");
        uint256 startTime = vm.envUint("START_TIME_MAINNET");

        vm.startBroadcast(deployerPrivateKey);

        deployed = FeeDistributor(
            create3.deploy(
                keccak256("FeeDistributor"),
                bytes.concat(type(FeeDistributor).creationCode, abi.encode(votingEscrow, startTime))
            )
        );

        vm.stopBroadcast();
    }
}
