pragma solidity ^0.8.24;

contract SomeToken {

    constructor(uint256 init_supply) {
    }

}

contract SomeTokenCreate {

    SomeToken public _someToken;

    function testSomeTokenCreate() public {
        // Create SomeToken
        _someToken = new SomeToken(1e18);
    }

}
