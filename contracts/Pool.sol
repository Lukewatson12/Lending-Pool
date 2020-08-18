//SPDX-License-Identifier: UNLICENSED

pragma solidity >= 0.6.0 <0.7.0;

import "./lib/SafeMath.sol";
import "./Treasury.sol";

contract Pool {
    using SafeMath for uint;

    address private owner;
    uint private totalTokens;

    Treasury private treasury;

    constructor() public {
        owner = msg.sender;
        treasury = new Treasury(this);
    }

    function deposit() public payable {
        require(msg.value > 0);

        treasury.deposit(
            msg.value,
            msg.sender,
            block.number * 14
        );
    }

    receive() external payable {
        deposit();
    }

    function viewDeposited(address _address) public view returns (uint amount) {
        return treasury.getDepositsForAddress(_address);
    }

    function withdrawTokens(uint _amount) public {
        require(totalTokens >= _amount, "Exceeding balance");
    }
}