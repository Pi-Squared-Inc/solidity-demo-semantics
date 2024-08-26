pragma solidity ^0.8.24;

contract IfTest {

    constructor() {
      bool x = true;
      bool y = false;
      if (x) {
        y = true;
      } else {
	require(false, "");
      }
      require(y, "");
      y = false;
      x = false;
      if (x) {
        require(false, "");
      } else {
        y = true;
      }
      require(y, "");
      if (x) {
        require(false, "");
      }
    }
}
