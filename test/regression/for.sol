pragma solidity ^0.8.24;

contract ForTest {

    constructor() {
      uint x = 5;
      uint y = 0;
      for (uint x = 0; x < 10; x = x + 1) {
        y = y + 2;
      }
      require(y == 20, "");
      require(x == 5, "");
    }
}
