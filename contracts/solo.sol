// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract Yakudza is AccessControl {
    address cronos = 0xA0b73E1Ff0B80914AB6fe0444E65848C4C34450b;

    bytes32 constant CAPRAL = keccak256("CAPRAL");

    address[] public yellowFrogs;

    constructor(){
        grantRole(DEFAULT_ADMIN_ROLE,msg.sender);
    }

    mapping (uint => Zbroya) pistols;
    mapping (address =>bool) alreadyanswered;

    struct Zbroya {
        uint id;
        uint price;
        string vyd;
        address owner;
    }

    function addZbroya(uint id,uint price,string memory vyd) external onlyRole(CAPRAL) {
        Zbroya storage g = pistols[id];
        g.price = price;
        g.vyd = vyd;

    }


    function rikSmertiAlcapone(uint answer) external {
        require(!alreadyanswered[msg.sender]); // alreadyanswered[msg.sender] = false;
        alreadyanswered[msg.sender] = true;
        if(answer == 1947) {
            yellowFrogs.push(msg.sender);
        } else {
            revert("You are a spy,we are going to kill you and your entire family!");
        }
    }

    function isHeYellowFrog(address man) public view returns(bool){
        for(uint i=0 ; i < yellowFrogs.length ;i++) {
            if(yellowFrogs[i]==man){ // таким чином одна людина може первірити іншу.
                return true;
            }
        }
        return false;
    }

    function payForAvtomat(uint id) external {
        require(isHeYellowFrog(msg.sender)==true);
        Zbroya storage g = pistols[id]; // storage оскільки призначаємо owner;
        uint Avtomat = g.price; // тимчасова змінна.
        IERC20(cronos).transferFrom(msg.sender,address(this),Avtomat);
        g.owner=msg.sender;
         
    }
}