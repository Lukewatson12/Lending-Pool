//SPDX-License-Identifier: UNLICENSED

pragma solidity >= 0.6.0 <0.7.0;

import "truffle/Assert.sol";
import "truffle/AssertString.sol";
import "truffle/DeployedAddresses.sol";
import "../../contracts/Pool.sol";

// These tests are better suited to the Treasury
contract TestPoolDeposit {
    uint public initialBalance = 1 ether;

    event ExceptionThrown(string message);

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

        // Gas is causing problems
        pool.deposit.value(10).gas(999999999)();
        pool.deposit.value(2).gas(999999999)();

        uint totalDeposited = pool.viewDeposited(address(this));

        Assert.equal(
            12,
            totalDeposited,
            "Deposited amount does not match amount deposited"
        );

        Assert.notEqual(
            13,
            totalDeposited,
            "Deposited amount is greater than amount deposited"
        );

        Assert.equal(
            12,
            pool.viewTreasuryBalance(),
            "Treasury balance is incorrect"
        );
    }

//    function testWithdrawal() public {
//        Pool pool = Pool(DeployedAddresses.Pool());
//
//        try pool.withdraw.gas(99999999)(400 wei) {
//            revert("There is not enough balance in the pool, exception should have thrown");
//        } catch (bytes memory exception) {
//            emit ExceptionThrown("testWithdrawal");
//        }
//
//        // Don't catch let it throw
//        pool.withdraw.gas(9999999999999)(10 wei);
//
//        Assert.equal(
//            2,
//            pool.viewDeposited(address(this)),
//            "Address balance has not been subtracted"
//        );
//        Assert.equal(
//            11,
//            pool.viewTreasuryBalance(),
//            "Treasury balance is incorrect"
//        );
//    }
}
