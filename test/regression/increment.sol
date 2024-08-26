pragma solidity ^0.8.24;

contract IncTest {

    constructor() {
      uint x = 0;
      require(x++ == 0, "");
      require(x == 1, "");      
      require(x-- == 1, "");
      require(x == 0, "");
    }
}
