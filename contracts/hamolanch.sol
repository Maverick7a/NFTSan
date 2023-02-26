// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";


contract hamolanche is AccessControl, ERC20{
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

    constructor() ERC20("hamolanche","HLA") {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(MINTER_ROLE,msg.sender);
        _setupRole(BURNER_ROLE, msg.sender);
    }

    function initializeStaking(address _staking) external onlyRole(DEFAULT_ADMIN_ROLE){
        _grantRole(MINTER_ROLE, _staking);
        _grantRole(BURNER_ROLE, _staking);
    }

    function mint(address _to, uint _amount) public onlyRole(MINTER_ROLE) {
        _mint(_to, _amount);
    }

    function burn(address _from, uint _amount) public onlyRole(BURNER_ROLE) {
        _burn(_from, _amount);
    }

}