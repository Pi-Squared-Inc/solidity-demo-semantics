pragma solidity ^0.8.24;

contract IfTest {

    constructor() {
      bool x = true;
      if (x) {
      } else {
	require(false, "");
      }
      x = false;
      if (x) {
        require(false, "");
      } else {
      }
      if (x) {
        require(false, "");
      }
    }
}
