// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.11;

import "forge-std/Test.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";
import {FeeDistributor} from "../src/FeeDistributor.sol";

contract FeeDistributorTest is Test {
    FeeDistributor constant f = FeeDistributor(0x951f99350d816c0E160A2C71DEfE828BdfC17f12);
    ERC20 constant weth = ERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    address constant user = 0x5f350bF5feE8e254D6077f8661E9C7B83a30364e;

    function setUp() external {}

    function test_distribute() external {
        // distribute WETH
        uint256 amount = 10 ether;
        deal(address(weth), address(this), amount);
        weth.approve(address(f), amount);
        f.depositToken(weth, amount);

        // wait for 1 hour
        skip(1 hours);

        // check claimable amount
        assertEq(f.claimToken(user, weth), 0, "claimed WETH");

        // wait for 10 hours
        skip(10 hours);

        // check claimable amount
        assertTrue(f.claimToken(user, weth) > 0, "didn't claim WETH");
    }
}