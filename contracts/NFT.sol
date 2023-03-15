//SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract Sanych is ERC1155, AccessControl {

    bytes32 public constant CREATOR_ROLE = keccak256("CREATOR ROLE");
    
    mapping(uint=> uint) public totalTokens;
    mapping(address => mapping(uint =>uint)) private balances;

    string public ipfsLocation;
    uint currentTokenId;


    uint public constant FunnySanych = 1;
    uint public constant CoolSanych = 2;
    uint public constant GyrinovskiySanych = 3;
    uint public constant SleepingSanych = 4;
    uint public constant InvalidSanych = 5;
    uint public constant SmokingSanych = 6;
    uint public constant MykolaiSanych = 7;
    uint public constant TankistSanych = 8;

    string name = "Varianty Sanycha";
    string symbol = "ELG";

    constructor(string memory _ipfsLocation) ERC1155(string(abi.encodePacked(_ipfsLocation, "{id}.json"))) {
        ipfsLocation = _ipfsLocation;
        _setupRole(DEFAULT_ADMIN_ROLE,msg.sender);
        
    }

    function mint(address _to , uint id, uint amount) external onlyRole(CREATOR_ROLE){
        _mint(_to, id, amount, "" );

        totalTokens[id] += amount;
        balances[_to][id] +=amount;
        }
    
    function burn(address _from , uint id, uint amount) external onlyRole(CREATOR_ROLE){
        _burn(_from, id , amount);

        totalTokens[id] -= amount;
        balances[_from][id] -=amount;
    }

    function totalKilkist(uint id) public view returns(uint256) {
        return totalTokens[id];
    }

    function checkBalance(address _to , uint id) public view returns (uint256){
        return balances[_to][id];
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC1155, AccessControl) returns (bool){
        return ERC1155.supportsInterface(interfaceId);
    }

    function addCreatorRole () external onlyRole (DEFAULT_ADMIN_ROLE){
        grantRole(CREATOR_ROLE, msg.sender
    }
}   