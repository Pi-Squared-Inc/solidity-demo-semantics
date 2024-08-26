pragma solidity ^0.8.24;

contract BoolTest {

    function fail() private {
      require(false, "");
    }

    constructor() {
      bool x = true;
      if (x || fail()) {
      } else {
        require(false, "");
      }
      if (x && true) {
      } else {
        require(false, "");
      }
      x = false;
      if (x && fail()) {
        require(false, "");
      }
      if (x || true) {
      } else {
        require(false, "");
      }
    }
}
