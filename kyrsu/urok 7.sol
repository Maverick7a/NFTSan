// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

contract Dem0 {
     //require
     //revert вказує тільки причину відмови транзакції, при ній потрібно писати if.
     //assert не вказує причину відмови транзакції
     address owner;

     event Paid(address indexed _from,uint _amount,uint _timestamp); // далі треба "породити" цей event в функції використовуючи emit.
     // при використанні indexed можна проводити пошук ,наприклад пошук хто зробив платіж.
     constructor() {
        owner = msg.sender;
     }

     receive() external payable{
        pay();
     }

     function pay() public payable {
        emit Paid(msg.sender,msg.value,block.timestamp);

     }

     address demoAddr; //0x00000000

     modifier onlyOwner(address _to) {
        require(msg.sender==owner,"you are not an owner!");
        require(_to != address(0),"incorect address" );
        _; // ця строка забезпечує вихід із модифікатора,після чого йде тіло функціїї (withdraw).
        // require(...); після тіла функції можна проводити перевірки.
        }

     function withdraw(address payable _to) external onlyOwner(_to) { //
        //require(msg.sender==owner,"you are not an owner!"); require писати не потрібно,бо він прописаний в modifier
        _to.transfer(address(this).balance);

     }

     //function withdraw(address payable _to) external {
       // assert(msg.sender==owner);
        //_to.transfer(address(this).balance);




     // function withdraw(address payable _to) external {
     // if(msg.sender!=owner) {
     // revert("you are not an owner!");
     //}

     //_to transfer(address(this).balance);
     //}
     }

     
