//SPDX-License-Identifier: UNLICENSED

pragma solidity >= 0.6.0 <0.7.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "./Shoal.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/payment/PaymentSplitter.sol";

// todo make ownable
contract Treasury {
    using SafeMath for uint;

    event DepositEvent(uint _amount, address _from, uint when);

    event WithdrawalEvent(uint _amount, uint _amountRemaining, address _to, uint when);

    event DepositWithdrawnEvent(uint _amount, address _to, uint when, bool isDepositEmpty);

    modifier withdrawalLimit(uint _amount, address _address) {
        require(addressBalances[_address] >= _amount, "Total withdrawal exceeds total deposited");
        _;
    }

    struct DepositStruct {
        uint _amount;
        address _address;
        uint _timeDeposit;
    }

    mapping(address => DepositStruct[]) public deposits;

    mapping(address => uint) public addressBalances;

    Shoal private shoal;

    constructor(Shoal _shoal) public {
        shoal = _shoal;
    }

    receive() payable external {
        deposit(msg.sender);
    }

    function deposit(address _address) payable public {
        uint timeDeposit = block.timestamp * 14;
        deposits[_address].push(
            DepositStruct(
                msg.value,
                _address,
                timeDeposit
            )
        );

        addressBalances[_address] = addressBalances[_address].add(msg.value);

        emit DepositEvent(msg.value, _address, timeDeposit);
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

    // Remember checks effects interaction
    function withdraw(address payable _address, uint _amount) external withdrawalLimit(_amount, _address) {
        handleFundBalancing(_address, _amount);
        addressBalances[_address] = addressBalances[_address].sub(_amount);

        emit WithdrawalEvent(_amount, addressBalances[_address], _address, block.timestamp * 14);

        _address.send(_amount);
    }

    // Could use a refactor
    function handleFundBalancing(address payable _address, uint _amountToWithdraw) internal {
        uint amountLeftToWithdraw = _amountToWithdraw;
        uint when = block.timestamp * 14;

        // Grab each deposit for address
        for (uint i = 0; i < deposits[_address].length; i++) {
            // Get amount in the deposit
            uint amountInDeposit = deposits[_address][i]._amount;

            // If the total amount in the deposit is equal or greater than the amount to withdraw we calculate the amount remaining
            if (amountInDeposit >= amountLeftToWithdraw) {
                uint remainder = amountInDeposit.sub(amountLeftToWithdraw);

                // If there is a remainder update the deposit
                if (remainder > 0) {
                    emit DepositWithdrawnEvent(amountLeftToWithdraw, _address, when, false);
                    deposits[_address][i]._amount = remainder;
                } else {
                    emit DepositWithdrawnEvent(amountLeftToWithdraw, _address, when, true);
                    delete deposits[_address][i];
                }
                break;
            }

            // Subtract the amount in the deposit from the amount to withdraw
            amountLeftToWithdraw = amountLeftToWithdraw.sub(amountInDeposit);
            emit DepositWithdrawnEvent(amountInDeposit, _address, when, true);
            delete deposits[_address][i];
        }
    }
}