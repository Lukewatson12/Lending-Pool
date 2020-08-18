//SPDX-License-Identifier: UNLICENSED

pragma solidity >= 0.6.0 <0.7.0;

import "./lib/SafeMath.sol";
import "./Pool.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/payment/PaymentSplitter.sol";

// todo make ownable
contract Treasury {
    using SafeMath for uint;

    event DepositEvent(uint _amount, address _from, uint when);

    modifier withdrawalLimit(uint _amount, address _address) {
        uint totalDeposited = getDepositsForAddress(_address);
        require(totalDeposited >= _amount, "Total withdrawal exceeds total deposited");
        _;
    }

    struct DepositStruct {
        uint _amount;
        address _address;
        uint _timeDeposit;
    }

    mapping(
    address => DepositStruct[]
    ) private deposits;

    Pool private pool;

    constructor(Pool _pool) public {
        pool = _pool;
    }

    function deposit(uint _amount, address _address, uint _timeDeposit) public {
        deposits[_address].push(DepositStruct(
                _amount,
                _address,
                _timeDeposit
            ));

        emit DepositEvent(_amount, _address, _timeDeposit);
    }

    function getDepositsForAddress(address _address) public view returns (uint amount) {
        require(deposits[_address].length > 0, "No deposits");
        uint totalDeposited = 0;

        for (uint i = 0; i < deposits[_address].length; i++) {
            uint amountInDeposit = deposits[_address][i]._amount;
            totalDeposited = totalDeposited.add(amountInDeposit);
        }

        return totalDeposited;
    }

    function withdraw(address _address, uint _amount) external withdrawalLimit(_amount, _address) {
        uint totalWithdrawn;

        for (uint i = 0; i < deposits[_address].length; i++) {
            uint amountInDeposit = deposits[_address][i]._amount;

            if (amountInDeposit >= totalWithdrawn) {
                // need to caclulate remainder
            }

            totalWithdrawn = totalWithdrawn.add(amountInDeposit);

//            deposits[_address][i].pop();
        }

    }
}