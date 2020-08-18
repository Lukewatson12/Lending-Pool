//SPDX-License-Identifier: UNLICENSED

pragma solidity >= 0.6.0 <0.7.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Pool.sol";

contract TestPoolDeposit {
    uint public initialBalance = 10 ether;

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
        uint amount = 1;

        address(pool).call.value(1 wei)(abi.encodeWithSignature("deposit()"));
        address(pool).call.value(3 wei)(abi.encodeWithSignature("deposit()"));

        uint totalDeposited = pool.viewDeposited(address(this));
        Assert.equal(
            pool.viewDeposited(address(this)),
            4,
            "The view method should tally up all deposits"
        );

        Assert.notEqual(
            pool.viewDeposited(address(this)),
            400,
            "The total amount returned should not equal 400"
        );
    }
}
