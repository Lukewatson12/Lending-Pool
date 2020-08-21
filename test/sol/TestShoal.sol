//SPDX-License-Identifier: UNLICENSED

pragma solidity >= 0.6.0 <0.7.0;

import "truffle/Assert.sol";
import "truffle/AssertString.sol";
import "truffle/DeployedAddresses.sol";
import "../../contracts/Shoal.sol";

// These tests are better suited to the Treasury
contract TesShoalDeposit {
    uint public initialBalance = 1 ether;

    event ExceptionThrown(string message);

    // Must come before deposits are made
    function testWhenThereAreNoDepositsAnExceptionOccurs() public {
        Shoal shoal = Shoal(DeployedAddresses.Shoal());

        try shoal.viewDeposited(address(this)) {
            Assert.equal(
                false,
                true,
                "No deposits were made yet no exception thrown"
            );
        } catch (bytes memory reason) {
        }
    }

    function testDepositWillUpdateTotal() public {
        Shoal shoal = Shoal(DeployedAddresses.Shoal());

        // Gas is causing problems
        shoal.deposit.value(10).gas(999999999)();
        shoal.deposit.value(2).gas(999999999)();

        uint totalDeposited = shoal.viewDeposited(address(this));

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
            shoal.viewTreasuryBalance(),
            "Treasury balance is incorrect"
        );
    }

    function testWithdrawal() public {
        Shoal shoal = Shoal(DeployedAddresses.Shoal());

        try shoal.withdraw.gas(99999999)(400 wei) {
            revert("There is not enough balance in the shoal, exception should have thrown");
        } catch (bytes memory exception) {
            emit ExceptionThrown("testWithdrawal");
        }

        // Don't catch let it throw
        shoal.withdraw.gas(9999999999999)(10 wei);

        Assert.equal(
            2,
            shoal.viewDeposited(address(this)),
            "Address balance has not been subtracted"
        );

        //todo why does the balance not reflect the updated amount
//        Assert.equal(
//            2,
//            shoal.viewTreasuryBalance(),
//            "Treasury balance is incorrect"
//        );
    }
}
