pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";


contract ShoalToken is ERC20 {
    using SafeMath for uint;

    constructor () public ERC20("Shoal", "FISH") {
        _mint(msg.sender, 0);
    }

    function mint(address _to, uint256 _amount) public virtual {
        _mint(_to, _amount);
    }

    // borrowed from https://stackoverflow.com/questions/42738640/division-in-ethereum-solidity
    function calculateShareOfTokens(address _who) public view returns (uint share) {
        uint precision = 6;

        uint _numerator = balanceOf(_who) * 10 ** (precision + 1);
        uint _quotient =  ((_numerator / totalSupply()) + 5) / 10;
        return ( _quotient);
    }
}
