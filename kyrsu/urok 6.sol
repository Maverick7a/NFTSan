//SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

contract Demo {
    // public функція відкривається зсериедини коду і зовні
    // external функція відкривається тільки зовні
    // internal функція відкривається тільки зсередини коду
    // private функція відкривається зсередини контракту,але недоступна для потомків цього контракту.

    // view читає дані але не модифікує(повертає значення)
    // pure не читає внутрішні дані
    string message = "hello!"; //state
    uint public balance;
    
    fallback() external payable{ // застосовується коли використовується функція яка не прописана в смарт-контракті.

    }
    receive() external payable{ // коли прописаний receive гроші які надійшли на смарт контракт не через функцію будуть зараховані.
        //balance +=msg.value; 
    }

    function pay() external payable {
        balance += msg.value; // можна записувати через коментар , гроші всерівно надійдуть у смарт контракт.
    }
    
    //transaction
    function setMessage(string memory newMessage) external {
        message = newMessage; // в такому випадку newMessage зберігається в блокчейн.
    }

    // call
    function getBalance() public view returns(uint){ // або function getBalance() public view returns(uint balance)
        uint balance= address(this).balance;         //     balance=address(this).balance
        return balance;                              //     return balance тоді не потрібно писати.

    }

    function getMessage() external view returns(string memory){ // pure не запрацює, оскільки саме повідомлення міститься в блокчейні
        return message;
    }

    function rate(uint amount) public pure returns(uint){ // в даному випадку ми не витягуємо інформацію з блокчейну.
        return amount * 3;
    }
}