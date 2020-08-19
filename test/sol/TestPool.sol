//SPDX-License-Identifier: UNLICENSED

pragma solidity >= 0.6.0 <0.7.0;

import "truffle/Assert.sol";
import "truffle/AssertString.sol";
import "truffle/DeployedAddresses.sol";
import "../../contracts/Pool.sol";

// These tests are better suited to the Treasury
contract TestPoolDeposit {
    uint public initialBalance = 1 ether;

    // Must come before deposits are made
    function testWhenThereAreNoDepositsAnExceptionOccurs() public {
        Pool pool = Pool(DeployedAddresses.Pool());
        uint amount = 1;

        try pool.viewDeposited(address(this)) {
            Assert.equal(
                false,
                true,
                "No deposits were made yet no exception thrown"
            );
        } catch (bytes memory reason) {
        }
    }

    function testDepositWillUpdateTotal() public {
        Pool pool = Pool(DeployedAddresses.Pool());

        pool.deposit.value(10).gas(999999999)();
        pool.deposit.value(2).gas(999999999)();

        uint totalDeposited = pool.viewDeposited(address(this));

        Assert.notEqual(
            13,
            totalDeposited,
            "Deposited amount is greater than amount deposited"
        );
    }
    //
    //    function testWithdrawal() public {
    //        Pool pool = Pool(DeployedAddresses.Pool());
    //        uint amount = 1 wei;
    //
    //        (bool success,) = address(pool).call(
    //            abi.encodePacked(
    //                pool.withdrawTokens.selector,
    //                abi.encode(address(this), amount)
    //            )
    //        );
    //
    //        Assert.equal(true, success, "Unable to withdraw, not enough balance");
    //    }
}
