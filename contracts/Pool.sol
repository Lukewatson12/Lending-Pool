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

        (bool success,) = address(treasury).call.value(msg.value)(
            abi.encodeWithSignature(
                "deposit(address)",
                msg.sender
            )
        );
    }

    receive() external payable {
        deposit();
    }

    function viewDeposited(address _address) public returns (uint amount) {
        return treasury.getDepositsForAddress(_address);
    }

    function withdrawTokens(address payable _address, uint _amount) public {
        require(_address == msg.sender, "You cannot withdraw on behalf of somebody else");
        require(totalTokens >= _amount, "Exceeding balance");

        treasury.withdraw(_address, _amount);
    }
}