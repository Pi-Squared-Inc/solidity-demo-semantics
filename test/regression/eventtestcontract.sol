pragma solidity ^0.8.24;

contract TestEventsContract {

    event Event0(uint256 arg0);
    event Event1(address arg0, address arg1, uint256 arg2);
    event Event2(address, address, uint256);

    event Event3(address indexed idxarg0);
    event Event4(address indexed);
    event Event5(address indexed idxarg0, address indexed idxarg1, uint256 arg2);
    event Event6(address indexed idxarg0, address indexed, uint256 arg2);
    event Event7(address indexed, address indexed idxarg1, uint256 arg2);
    event Event8(address indexed, address indexed, uint256 indexed);

    constructor() {}
}

