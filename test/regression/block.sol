pragma solidity ^0.8.24;

contract BlockTest {

    constructor() {
      bool x = false;
      {
        bool x = true;
	require(x, "");
      }
      if (x) {
        require(false, "");
      }
    }
}
