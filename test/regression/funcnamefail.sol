pragma solidity ^0.8.24;

contract FuncNameFailTest {

    function chaincall2() private returns (uint) {
        require(false, "");
        return 2;
    }

    function chaincall1() private returns (uint) {
       return chaincall2();
    }

    constructor() {
      uint x = chaincall1();
    }
}
