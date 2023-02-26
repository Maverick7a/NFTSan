// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract MyVapeShop is AccessControl {

    address cronos = 0xA0b73E1Ff0B80914AB6fe0444E65848C4C34450b;

    bytes32 constant Todo = keccak256("Todo");

    mapping(uint=> HQD) dytka;

    address[] Vape;


    constructor (){
        grantRole(DEFAULT_ADMIN_ROLE,msg.sender);
    }
    
    struct HQD { 
        uint id;
        uint price;
        string smak;
        uint kilkist;
        uint orendaprice;
    }

    function addVape(uint id,string memory _smak,uint _price) public onlyRole(Todo){
        HQD storage g = dytka[id];
        g.price=_price;
        g.smak=_smak;
        g.kilkist++;
    }

    function buyVape(uint id) public{
       HQD memory g = dytka[id];
        require(Vape.length < 50 , "Vapes are sold");
        IERC20(cronos).transferFrom(msg.sender,address(this),g.price);
        Vape.push(msg.sender);
        g.kilkist-=1;
    }

    function getVapeInfo(uint id) public view returns(uint,string memory){
        HQD memory g = dytka[id];
        return(g.price,g.smak);
        }
    

    function withdraw (uint groshi) public  onlyRole(DEFAULT_ADMIN_ROLE){
        IERC20 (cronos).transfer(msg.sender,groshi);
        }

    function checkCurrentBalance() public view returns(uint balance){
        return IERC20(cronos).balanceOf(address(this));
    }

    function orendaVaype(uint id) public {
        require(block.timestamp>= 16725240000 && block.timestamp<= 1674856800,"Orenda Zakinchena");
        HQD memory g = dytka[id];
        require(g.price!=0,"Orenda Nedostypna");
        IERC20(cronos).transferFrom(msg.sender,address(this),g.orendaprice);

    }
}