pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract ShoalToken is ERC20 {

    constructor () public ERC20("Shoal", "FISH") {
        _mint(msg.sender, 0);
    }

    function mint(address to, uint256 amount) public virtual {
        _mint(to, amount);
    }
}
