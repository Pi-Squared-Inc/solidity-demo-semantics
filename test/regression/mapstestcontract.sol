pragma solidity ^0.8.24;

contract TestMapsContract {

    mapping(address => uint256) public testMap;
    mapping(address key => uint256 val) public testMapWithOptIds;
    mapping(address => mapping(uint256 => address)) private testNestedMap;

    constructor() {}
}
