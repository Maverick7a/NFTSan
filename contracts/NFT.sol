//SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract Sanych is ERC1155, AccessControl {

    bytes32 public constant CREATOR_ROLE = keccak256("CREATOR ROLE");
    
    string public name = "Varianty Sanycha";
    string public symbol = "ELG";

    constructor() 
        ERC1155(
            "https://gateway.pinata.cloud/ipfs/QmPZohs8BuZ46dJYEZk1RoLuAnNmuL7jjkR9vYmi81A87i/{id}.json"
        ) 
    {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(CREATOR_ROLE, msg.sender);
    }

    function mint(
        address _to,
        uint256 _id,
        uint256 _amount,
        bytes memory _data
    ) public onlyRole(CREATOR_ROLE) {
        _mint(_to, _id, _amount, _data);
    }

    function mintBatch(
        address _to,
        uint256[] memory _id,
        uint256[] memory _amount,
        bytes memory _data
    ) public onlyRole(CREATOR_ROLE) {
        _mintBatch(_to, _id, _amount, _data);
    }
    
    function burn(address _from , uint id, uint amount) external onlyRole(CREATOR_ROLE){
        _burn(_from, id , amount);

    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(AccessControl, ERC1155)
        returns (bool)
    {
        return
            interfaceId == type(IAccessControl).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    function addCreatorRole () external onlyRole (DEFAULT_ADMIN_ROLE){
        grantRole(CREATOR_ROLE, msg.sender);
    }

    function uri(uint256 _id) public pure override returns (string memory) {
        return
            string(
                abi.encodePacked(
                    "https://gateway.pinata.cloud/ipfs/QmPZohs8BuZ46dJYEZk1RoLuAnNmuL7jjkR9vYmi81A87i/",
                    Strings.toString(_id),
                    ".json"
                )
            );
    }
}   
// rpc endpoint
//npx hardhat + 2 file
//npm i  
//git remote add origin culka
