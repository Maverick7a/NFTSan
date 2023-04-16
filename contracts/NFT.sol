//SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract Sanych is ERC1155, AccessControl {

    bytes32 public constant CREATOR_ROLE = keccak256("CREATOR ROLE");
    
    mapping(uint=> uint) public totalTokens;
    mapping(address => mapping(uint =>uint)) private balances;

    string public ipfsLocation = "https://gateway.pinata.cloud/ipfs/QmXmW9V1ZrSr5NdxfbZCtHaUx7UUqqSPnw7axLjH34Nkp7";
    uint currentTokenId;

    string name = "Varianty Sanycha";
    string symbol = "ELG";

    constructor() 
        ERC1155(
            "https://gateway.pinata.cloud/ipfs/QmXmW9V1ZrSr5NdxfbZCtHaUx7UUqqSPnw7axLjH34Nkp7/{id}.json"
        ) 
    {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
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
        grantRole(CREATOR_ROLE, msg.sender);
    }

    function uri(uint256 _id) public pure override returns (string memory) {
        return
            string(
                abi.encodePacked(
                    "https://gateway.pinata.cloud/ipfs/QmXmW9V1ZrSr5NdxfbZCtHaUx7UUqqSPnw7axLjH34Nkp7",
                    Strings.toString(_id),
                    ".json"
                )
            );
    }
}   