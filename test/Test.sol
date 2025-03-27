// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.11;

import "forge-std/Test.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";
import {FeeDistributor} from "../src/FeeDistributor.sol";
import {IVotingEscrow} from "../src/interfaces/IVotingEscrow.sol";

contract FeeDistributorTest is Test {
    FeeDistributor public f;
    ERC20 constant weth = ERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    IVotingEscrow constant votingEscrow = IVotingEscrow(0x00000042877f4a1cC0693383ebdAc7c0e0A1bf77);
    address constant user = 0x5f350bF5feE8e254D6077f8661E9C7B83a30364e;

    function setUp() external {
        // Select mainnet fork
        vm.createSelectFork("mainnet");

        // Deploy FeeDistributor with current timestamp as start time
        f = new FeeDistributor(votingEscrow, block.timestamp);
    }

    function test_distribute() external {
        // distribute WETH
        uint256 amount = 10 ether;
        deal(address(weth), address(this), amount);
        weth.approve(address(f), amount);
        f.depositToken(weth, amount);

        // wait for 1 week
        skip(1 weeks);

        // check claimable amount
        assertTrue(f.claimToken(user, weth) > 0, "didn't claim WETH");
    }
}
