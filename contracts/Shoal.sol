//SPDX-License-Identifier: UNLICENSED

pragma solidity >= 0.6.0 <0.7.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "./lending/ShoalLendPool.sol";
import "./Treasury.sol";
import "./ShoalToken.sol";

contract Shoal {
    using SafeMath for uint;

    address private owner;

    Treasury private treasury;

    ShoalLendPool private shoalLendPool;

    ShoalToken private shoal;

    constructor() public {
        owner = msg.sender;
        treasury = new Treasury(this);

        shoalLendPool = new ShoalLendPool(
            new ShoalToken()
        );
    }

    function deposit() public payable {
        require(msg.value > 0);

        (bool success,) = address(treasury).call.value(msg.value)(
            abi.encodeWithSignature(
                "deposit(address)",
                msg.sender
            )
        );

        if (false == success) {
            revert();
        }
    }

    receive() external payable {
        deposit();
    }

    function viewDeposited(address _address) public view returns (uint amount) {
        return treasury.getDepositsForAddress(_address);
    }

    function viewTreasuryBalance() public view returns (uint) {
        return address(treasury).balance;
    }

    function withdraw(uint _amount) public {
        require(address(treasury).balance >= _amount, "There is not enough funds in the Treasury");

        treasury.withdraw(msg.sender, _amount);
    }
}
