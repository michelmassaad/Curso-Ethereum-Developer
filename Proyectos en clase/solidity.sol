// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.0;

contract Message {
    // variables de estado
    /*
     comentarios
     de mas
     lineas
    */
    string private message;
    address public sender;
    address public origin;
    address public owner;

    event MessageSet(address indexed who, string mensaje); // 4 topics

    modifier onlyOwner() {
        if(msg.sender!=owner) revert();
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function setMessage(string calldata _message) public {
        message = _message;
        sender = msg.sender;
        origin = tx.origin;
        emit MessageSet(msg.sender,_message);
    }

    function getMessage() external view returns(string memory) {
        return message;
    }

    function sum(uint256 a, uint256 b) external pure returns(uint256) {
        return a+b;
    }
}